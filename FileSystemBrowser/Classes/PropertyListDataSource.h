//
//  PropertyListDataSource.h
//  FileSystemBrowser
//

#import <Foundation/Foundation.h>
#import "LoadCellFromNibDataSource.h"

@interface PropertyListDataSource : LoadCellFromNibDataSource {
	NSString *path;
	id propertyList;
	NSMutableArray *rows;
}

@property (nonatomic,copy) NSString *path;
@property (nonatomic,retain) id propertyList;
@property (nonatomic,retain) NSMutableArray *rows;

- (id)initWithPath:(NSString*)path;

@end

