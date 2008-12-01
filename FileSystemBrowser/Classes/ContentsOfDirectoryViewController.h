//
//  ContentsOfDirectoryViewController.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>
#import "ContentsOfDirectoryDataSource.h"

@interface ContentsOfDirectoryViewController : UIViewController<UITableViewDelegate> {
	UITableView *tableView;
	NSString* path;
	ContentsOfDirectoryDataSource* contentsOfDirectory;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString* path;
@property (nonatomic,retain) ContentsOfDirectoryDataSource* contentsOfDirectory;

@end
