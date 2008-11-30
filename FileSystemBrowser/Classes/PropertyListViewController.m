//
//  PropertyListViewController.m
//  FileSystemBrowser
//

#import "PropertyListViewController.h"

@implementation PropertyListViewController

@synthesize path;

- (void)dealloc {
	[path release];
    [super dealloc];
}


#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//	[tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


@end
