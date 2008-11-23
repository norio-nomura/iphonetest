//
//  SubclassesWithImageSectionsDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>
#import "IndexedDataSource.h"

@interface NSObject(indexedDictionary_imageFromClass)
- (NSString*)imageFromClassName;
@end

@interface SubclassesWithImageSectionsDataSource : IndexedDataSource {
}

- (id)initWithArray:(NSArray*)array;

@end
