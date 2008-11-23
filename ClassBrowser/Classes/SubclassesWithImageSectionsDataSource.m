//
//  SubclassesWithImageSectionsDataSource.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "SubclassesWithImageSectionsDataSource.h"

@implementation NSObject(indexedDictionary_imageFromClass)


- (NSString*)imageFromClassName {
	Class class = objc_getClass([[self description] cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		NSString *imagePath = [NSString stringWithCString:class_getImageName(class) encoding:NSNEXTSTEPStringEncoding];
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
	return [super initWithArray:array usingSelector:@selector(imageFromClassName)];
}


#pragma mark UITableViewDataSource Protocol


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return nil;
}


@end
