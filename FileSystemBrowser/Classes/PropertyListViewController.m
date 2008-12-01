//
//  PropertyListViewController.m
//  FileSystemBrowser
//

#import "PropertyListViewController.h"
#import "PropertyListCell.h"

@implementation PropertyListViewController

@synthesize tableView;
@synthesize path;
@synthesize propertyList;


- (void)setPath:(NSString*)obj {
	if (path != obj) {
		[path release];
		path = [obj retain];
		self.title = [path lastPathComponent];
	}
}


- (void)dealloc {
	[tableView release];
	[path release];
	[propertyList release];
    [super dealloc];
}


- (void)toggleOutline:(PropertyListCell*)cell {
	NSIndexPath *uiIndexPath = [tableView indexPathForCell:cell];
	if (cell.indicator.selected) {
		cell.indicator.selected = NO;
		NSArray *uiIndexPathes = [propertyList newCollapseChild:uiIndexPath];
		if (uiIndexPathes) {
			[tableView deleteRowsAtIndexPaths:uiIndexPathes withRowAnimation:UITableViewRowAnimationTop];
			[uiIndexPathes release];
		}
	} else {
		cell.indicator.selected = YES;
		NSArray *uiIndexPathes = [propertyList newExpandChild:uiIndexPath];
		if (uiIndexPathes) {
			[tableView insertRowsAtIndexPaths:uiIndexPathes withRowAnimation:UITableViewRowAnimationTop];
			[uiIndexPathes release];
		}
	}
}


#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	PropertyListDataSource *dataSource = [[PropertyListDataSource alloc] initWithPath:path];
	dataSource.viewController = self;
	self.propertyList = dataSource;
	[dataSource release];
	tableView.dataSource = self.propertyList;
	[tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
