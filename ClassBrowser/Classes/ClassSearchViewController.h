//
//  ClassSearchViewController.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@class IndexedDataSource;

@interface ClassSearchViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate> {
	UITableView *tableView;
	UISegmentedControl *segmentedControl;
	IndexedDataSource *dataSource;
	IndexedDataSource *initialDataSource;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IndexedDataSource *dataSource;
@property (nonatomic,retain) IndexedDataSource *initialDataSource;


@end
