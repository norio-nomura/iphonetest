//
//  PropertyListDataSource.h
//  FileSystemBrowser
//

#import <Foundation/Foundation.h>
#import "LoadCellFromNibDataSource.h"

@class PropertyListViewController;

@interface PropertyListDataSource : LoadCellFromNibDataSource {
	NSString *path;
	id propertyList;
	NSArray *nodes;
	NSMutableArray *rowToIndexPath;
	PropertyListViewController *viewController;
}

@property (nonatomic,copy) NSString *path;
@property (nonatomic,retain) id propertyList;
@property (nonatomic,retain) NSArray *nodes;
@property (nonatomic,retain) NSMutableArray *rowToIndexPath;
@property (nonatomic,assign) PropertyListViewController *viewController;

- (id)initWithPath:(NSString*)aPath;
- (NSArray*)newExpandChild:(NSIndexPath*)uiIndexPath;
- (NSArray*)newCollapseChild:(NSIndexPath*)uiIndexPath;

@end

