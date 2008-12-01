//
//  ContentsOfDirectoryViewController.m
//  FileSystemBrowser
//

#import "ContentsOfDirectoryViewController.h"
#import "FileSystemBrowserAppDelegate.h"

@implementation ContentsOfDirectoryViewController

@synthesize tableView;
@synthesize path;
@synthesize contentsOfDirectory;


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
	[contentsOfDirectory release];
    [super dealloc];
}


#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	ContentsOfDirectoryDataSource* dataSource = [[ContentsOfDirectoryDataSource alloc] initWithPath:path];
	self.contentsOfDirectory = dataSource;
	[dataSource release];
	tableView.dataSource = self.contentsOfDirectory;
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
	NSString *pathComponent = [contentsOfDirectory objectForRowAtIndexPath:indexPath];
	FileSystemBrowserAppDelegate *appDelegate = (FileSystemBrowserAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate pushViewControllerWithPath:[path stringByAppendingPathComponent:pathComponent]];
}


@end

