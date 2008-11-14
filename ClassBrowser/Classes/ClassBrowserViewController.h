//
//  ClassBrowserViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@interface ClassBrowserViewController : UIViewController<UITableViewDelegate,UITabBarDelegate> {
	UITableView *tableView;
	UITabBar *tabBar;
	@private
	NSArray *dataSourcesArray_;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITabBar* tabBar;
@property (readonly) NSArray *dataSourcesArray;

@end

