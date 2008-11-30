//
//  ClassBrowserViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@interface ClassBrowserViewController : UIViewController<UITableViewDelegate,UITabBarDelegate> {
	UITableView *tableView;
	UITabBar *tabBar;
	UITabBarItem *itemSubclasses;
	UITabBarItem *itemProperties;
	UITabBarItem *itemClassMethods;
	UITabBarItem *itemInstanceMethods;
	UITabBarItem *itemProtocols;
	UITabBarItem *itemInstanceVariables;
	UIBarButtonItem *classSearchButtonItem;
	NSMutableArray *dataSourcesArray;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITabBar* tabBar;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemSubclasses;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemProperties;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemClassMethods;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemInstanceMethods;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemProtocols;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemInstanceVariables;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *classSearchButtonItem;
@property (nonatomic,retain) NSMutableArray *dataSourcesArray;

- (IBAction)showClassSearch:(id)sender;
- (void)selectSubclassRow:(NSString*)className;

@end
