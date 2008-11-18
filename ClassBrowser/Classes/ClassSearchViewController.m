//
//  ClassSearchViewController.m
//  ClassBrowser
//


#import <objc/runtime.h>
#import "ClassBrowserAppDelegate.h"
#import "ClassSearchViewController.h"
#import "ClassTree.h"
#import "SubclassesDataSource.h"


@implementation ClassSearchViewController


@synthesize tableView;
@synthesize segmentedControl;
@synthesize dataSource;
@synthesize initialDataSource;


- (void)dealloc {
	[tableView release];
	[segmentedControl release];
	[dataSource release];
	[initialDataSource release];
    [super dealloc];
}


#pragma mark UIViewController Class


- (void)viewDidLoad {
	SubclassesDataSource * subclassesDataSource = [[SubclassesDataSource alloc] initWithArray:[[ClassTree sharedClassTree].classDictionary allKeys]];
	self.initialDataSource = subclassesDataSource;
	self.dataSource = subclassesDataSource;
	[subclassesDataSource release];
	tableView.dataSource = self.dataSource;
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


#pragma mark UITableViewDelegate Protocol


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (segmentedControl.selectedSegmentIndex == 0) {
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate pushClass:[[(SubclassesDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath] description]];
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		NSString *className = [(SubclassesDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath];
		NSMutableArray *tree = [[NSMutableArray alloc] initWithObjects:className,nil];
		NSString *superClassName = [NSString stringWithCString:class_getName(class_getSuperclass(objc_getClass([className cStringUsingEncoding:NSNEXTSTEPStringEncoding]))) encoding:NSNEXTSTEPStringEncoding];
		while (![superClassName isEqualToString:@"nil"]) {
			[tree addObject:superClassName];
			superClassName = [NSString stringWithCString:class_getName(class_getSuperclass(objc_getClass([superClassName cStringUsingEncoding:NSNEXTSTEPStringEncoding]))) encoding:NSNEXTSTEPStringEncoding];
		}
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate performSelector:@selector(pushClassTree:) withObject:tree afterDelay:0.1];
		[tree release];
	}
}


#pragma mark UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSArray *classNamesArray = [[[ClassTree sharedClassTree].classDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:[classNamesArray count]];
	for (NSString *className in classNamesArray) {
		NSComparisonResult result = [className compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame) {
			[filteredArray addObject:className];
		}
	}
	SubclassesDataSource * subclassesDataSource = [[SubclassesDataSource alloc] initWithArray:filteredArray];
	self.dataSource = subclassesDataSource;
	[subclassesDataSource release];
	tableView.dataSource = self.dataSource;
	[tableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if (searchBar.text.length > 0) {
		self.tableView.dataSource = self.initialDataSource;
	}
	
	[tableView reloadData];
	
	[searchBar resignFirstResponder];
	searchBar.text = @"";
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
}


@end
