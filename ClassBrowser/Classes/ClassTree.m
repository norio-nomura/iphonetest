//
//  ClassTree.m
//  ClassBrowser
//

#import <dlfcn.h>
#import <objc/runtime.h>
#import "ClassTree.h"

@implementation ClassTree

@synthesize classDictionary = classDictionary_;
@synthesize subclassesDataSource = subclassesDataSource_;
@synthesize subclassesWithImageSectionsDataSource = subclassesWithImageSectionsDataSource_;

static ClassTree *sharedClassTreeInstance = nil;


+ (ClassTree*)sharedClassTree {
    @synchronized(self) {
        if (sharedClassTreeInstance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedClassTreeInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedClassTreeInstance == nil) {
            sharedClassTreeInstance = [super allocWithZone:zone];
            return sharedClassTreeInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)retain {
    return self;
}


- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}


- (void)release {
    //do nothing
}


- (id)autorelease {
    return self;
}


- (void)dealloc {
	[classDictionary_ release];
	[subclassesDataSource_ release];
	[subclassesWithImageSectionsDataSource_ release];
	[super dealloc];
}


- (void)setupClassDictionary {
	classDictionary_ = [[NSMutableDictionary alloc]initWithCapacity:3000];
	NSMutableDictionary *subclassDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	[classDictionary_ setObject:subclassDictionary forKey:KEY_ROOT_CLASSES];
	[subclassDictionary release];
	
	int numberOfClasses = objc_getClassList(NULL,0);
	Class classes[numberOfClasses];
	if (objc_getClassList(classes,numberOfClasses)) {
		for (int i = 0; i < numberOfClasses; i++) {
			Class class = classes[i];
			NSString *className = nil;
			NSString *subClassName = nil;
			while (class) {
				className = [NSString stringWithCString:class_getName(class) encoding:NSNEXTSTEPStringEncoding];
				if (!(subclassDictionary = [classDictionary_ objectForKey:className])) {
					subclassDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
					[classDictionary_ setObject:subclassDictionary forKey:className];
					[subclassDictionary release];
				}
				if (subClassName) {
					[subclassDictionary setObject:[classDictionary_ objectForKey:subClassName] forKey:subClassName];
				}
				subClassName = className;
				class = class_getSuperclass(class);
			}
			[[classDictionary_ objectForKey:KEY_ROOT_CLASSES] setObject:[classDictionary_ objectForKey:subClassName] forKey:subClassName];
		}
	}

	subclassesDataSource_ = [[SubclassesDataSource alloc] initWithArray:[classDictionary_ allKeys]];
	subclassesWithImageSectionsDataSource_ = [[SubclassesWithImageSectionsDataSource alloc] initWithArray:[classDictionary_ allKeys]];
}


- (void)loadAllFrameworks {
	NSArray *allLibrariesPath = NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory,NSSystemDomainMask,NO);
	NSArray *ignorePaths = NSSearchPathForDirectoriesInDomains(NSDeveloperDirectory,NSSystemDomainMask,NO);
	NSMutableArray *searchPaths = [allLibrariesPath mutableCopy];
	[searchPaths removeObjectsInArray:ignorePaths];
	for (NSString *path in searchPaths) {
		NSString *file, *libraryPath;
		NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
		while (file = [dirEnum nextObject]) {
			NSArray *components = [file pathComponents];
			if ([components count] > 2 && 
				[[components objectAtIndex:[components count]-2] hasSuffix:@".framework"] && 
				[[components objectAtIndex:[components count]-2] hasPrefix:[components lastObject]] &&
				[[[components lastObject] pathExtension] isEqualToString: @""]) {
				libraryPath = [path stringByAppendingPathComponent:file];
				dlopen([libraryPath cStringUsingEncoding:NSNEXTSTEPStringEncoding],RTLD_NOW|RTLD_GLOBAL);
			}
		}
	}
	[searchPaths release];
}


@end
