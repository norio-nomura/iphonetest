//
//  ClassTree.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>
#import "SubclassesDataSource.h"
#import "SubclassesWithImageSectionsDataSource.h"

#define KEY_ROOT_CLASSES @"Root Classes"

@interface ClassTree : NSObject {
	NSMutableDictionary *classDictionary_;
	SubclassesDataSource *subclassesDataSource_;
	SubclassesWithImageSectionsDataSource *subclassesWithImageSectionsDataSource_;
}

@property (retain,readonly) NSDictionary *classDictionary;
@property (retain,readonly) SubclassesDataSource *subclassesDataSource;
@property (retain,readonly) SubclassesWithImageSectionsDataSource *subclassesWithImageSectionsDataSource;

+ (ClassTree*)sharedClassTree;
- (void)setupClassDictionary;
- (void)loadAllFrameworks;

@end
