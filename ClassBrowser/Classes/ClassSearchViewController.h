//
//  ClassSearchViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@class IndexedDataSource;

@interface ClassSearchViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate,UITabBarDelegate> {
	UITableView *tableView;
	UISegmentedControl *segmentedControl;
	UITabBar *tabBar;
	NSMutableArray *dataSourcesArray_;
	NSMutableArray *initialDataSourcesArray_;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IBOutlet UITabBar *tabBar;
@property (nonatomic,retain) NSMutableArray *dataSourcesArray;
@property (nonatomic,retain) NSMutableArray *initialDataSourcesArray;


@end
