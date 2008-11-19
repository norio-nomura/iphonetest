//
//  SubclassesWithImageSectionsDataSource.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "SubclassesWithImageSectionsDataSource.h"

@implementation NSObject(indexedDictionary_imageFromClass)

- (NSString*)imageFromClass {
	Class class = objc_getClass([[self description] cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		NSString *imagePath = [NSString stringWithCString:class_getImageName(class)];
		NSArray *components = [imagePath pathComponents];
		if ([components count]>2) {
			NSRange rangeLastThree;
			rangeLastThree.location = [components count] - 2;
			rangeLastThree.length = 2;
			return [NSString pathWithComponents:[components subarrayWithRange:rangeLastThree]];
		} else {
			return imagePath;
		}
	} else {
		return nil;
	}
}

@end

@implementation SubclassesWithImageSectionsDataSource


- (id)initWithArray:(NSArray*)array {
	if (self = [super initWithDictionary:[array indexedDictionaryWithIndexSelector:@selector(imageFromClass)]]) {
	}
	return self;
}

#pragma mark UITableViewDataSource Protocol


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return nil;
}


@end
