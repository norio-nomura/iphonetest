//
//  SubclassesWithImageSectionsDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>
#import "IndexedDataSource.h"

@interface NSObject(indexedDictionary_imageFromClass)
- (NSString*)imageFromClass;
@end

@interface SubclassesWithImageSectionsDataSource : IndexedDataSource {

}

- (id)initWithArray:(NSArray*)array;

@end
