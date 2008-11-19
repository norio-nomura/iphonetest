//
//  ClassTree.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassTree.h"


@interface ClassTree(private)
- (void)setupClassDictionary;
@end

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
	[super dealloc];
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (void)setupClassDictionary {
	classDictionary_ = [[NSMutableDictionary alloc]initWithCapacity:1000];
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
				className = [NSString stringWithCString:class_getName(class)];
				subclassDictionary = [classDictionary_ objectForKey:className];
				if (!subclassDictionary) {
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

@end
