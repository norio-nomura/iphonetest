//
//  ClassBrowserViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@interface ClassBrowserViewController : UIViewController<UITableViewDelegate,UITabBarDelegate> {
	UITableView *tableView;
	UITabBar *tabBar;
	UIBarButtonItem *classSearchButtonItem;
	@private
	NSArray *dataSourcesArray_;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITabBar* tabBar;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *classSearchButtonItem;
@property (readonly) NSArray *dataSourcesArray;

- (void)loadDataSources;

- (IBAction)showClassSearch:(id)sender;

@end

