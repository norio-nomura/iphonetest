//
//  ClassTree.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

#define KEY_ROOT_CLASSES @"Root Classes"

@interface ClassTree : NSObject {
	NSMutableDictionary *classDictionary_;
}

@property (retain,readonly) NSDictionary *classDictionary;

+ (ClassTree*)sharedClassTree;

@end
