//
//  ProtocolBrowserViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>


@interface ProtocolBrowserViewController : UIViewController<UITableViewDelegate,UITabBarDelegate> {
	UITableView *tableView;
	UITabBar *tabBar;
	UITabBarItem *itemProtocols;
	UITabBarItem *itemProperties;
	UITabBarItem *itemRequiredMethods;
	UITabBarItem *itemOptionalMethods;
	NSMutableArray *dataSourcesArray;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITabBar* tabBar;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemProtocols;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemProperties;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemRequiredMethods;
@property (nonatomic,retain) IBOutlet UITabBarItem *itemOptionalMethods;
@property (nonatomic,retain) NSMutableArray *dataSourcesArray;

@end
