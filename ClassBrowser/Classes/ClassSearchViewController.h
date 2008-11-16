//
//  ClassSearchViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@class ClassDataSource;

@interface ClassSearchViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate> {
	UITableView *tableView;
	UISegmentedControl *segmentedControl;
	ClassDataSource *dataSource;
	ClassDataSource *initialDataSource;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) ClassDataSource *dataSource;
@property (nonatomic,retain) ClassDataSource *initialDataSource;


@end
