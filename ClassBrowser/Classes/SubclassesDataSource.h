//
//  SubclassesDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>
#import "IndexedDataSource.h"

@interface SubclassesDataSource : IndexedDataSource {
}

- (id)initWithArray:(NSArray*)array;

@end
