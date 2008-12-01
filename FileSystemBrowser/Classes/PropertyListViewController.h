//
//  PropertyListViewController.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>
#import "PropertyListDataSource.h"

@class PropertyListCell;

@interface PropertyListViewController : UIViewController {
	UITableView *tableView;
	NSString *path;
	PropertyListDataSource *propertyList;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString* path;
@property (nonatomic,retain) PropertyListDataSource *propertyList;

- (void)toggleOutline:(PropertyListCell*)cell;

@end
