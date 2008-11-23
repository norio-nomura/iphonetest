//
//  ClassSearchViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@interface ClassSearchViewController : UIViewController<UITableViewDelegate,UITabBarDelegate,UISearchBarDelegate> {
	UITableView *tableView;
	UISegmentedControl *segmentedControl;
	UISearchBar *searchBar;
	UITabBar *tabBar;
	@private
	NSMutableArray *dataSourcesArray;
	NSMutableArray *initialDataSourcesArray;
	NSString *previousSearchText;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) IBOutlet UITabBar *tabBar;
@property (nonatomic,retain) NSMutableArray *dataSourcesArray;
@property (nonatomic,retain) NSMutableArray *initialDataSourcesArray;
@property (nonatomic,copy) NSString *previousSearchText;

@end
