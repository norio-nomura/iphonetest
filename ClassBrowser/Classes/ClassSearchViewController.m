//
//  ClassSearchViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserAppDelegate.h"
#import "ClassSearchViewController.h"
#import "ClassTree.h"
#import "SubclassesDataSource.h"
#import "SubclassesWithImageSectionsDataSource.h"


@implementation ClassSearchViewController


@synthesize tableView;
@synthesize segmentedControl;
@synthesize tabBar;
@synthesize dataSourcesArray = dataSourcesArray_;
@synthesize initialDataSourcesArray = initialDataSourcesArray_;


- (void)dealloc {
	[tableView release];
	[segmentedControl release];
	[tabBar release];
	[dataSourcesArray_ release];
	[initialDataSourcesArray_ release];
    [super dealloc];
}


#pragma mark UIViewController Class


- (void)viewDidLoad {
	NSUInteger tag = 0;
	dataSourcesArray_ = [[NSMutableArray alloc] initWithCapacity:2];
	initialDataSourcesArray_ = [[NSMutableArray alloc] initWithCapacity:2];
	
	[self.dataSourcesArray addObject:[ClassTree sharedClassTree].subclassesDataSource];
	[self.initialDataSourcesArray addObject:[ClassTree sharedClassTree].subclassesDataSource];
	[[[self.tabBar items] objectAtIndex:[self.dataSourcesArray count]-1] setTag:tag++];

	[self.dataSourcesArray addObject:[ClassTree sharedClassTree].subclassesWithImageSectionsDataSource];
	[self.initialDataSourcesArray addObject:[ClassTree sharedClassTree].subclassesWithImageSectionsDataSource];
	[[[self.tabBar items] objectAtIndex:[self.dataSourcesArray count]-1] setTag:tag++];
	
	self.tabBar.selectedItem = [tabBar.items objectAtIndex:0];
	tableView.dataSource = [self.dataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
	[self.tableView reloadData];
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
		[appDelegate pushClass:[[(IndexedDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath] description]];
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		NSString *className = [(IndexedDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath];
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
	if (searchBar.text.length > 0) {
		NSArray *classNamesArray = [[[ClassTree sharedClassTree].classDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:[classNamesArray count]];
		for (NSString *className in classNamesArray) {
			NSComparisonResult result = [className compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])];
			if (result == NSOrderedSame) {
				[filteredArray addObject:className];
			}
		}
		SubclassesDataSource * subclassesDataSource = [[SubclassesDataSource alloc] initWithArray:filteredArray];
		[self.dataSourcesArray replaceObjectAtIndex:0 withObject:subclassesDataSource];
		[subclassesDataSource release];
		SubclassesWithImageSectionsDataSource *subclassesWithImageSectionsDataSource = [[SubclassesWithImageSectionsDataSource alloc] initWithArray:filteredArray];
		[self.dataSourcesArray replaceObjectAtIndex:1 withObject:subclassesWithImageSectionsDataSource];
		[subclassesWithImageSectionsDataSource release];
	} else {
		[self.dataSourcesArray replaceObjectAtIndex:0 withObject:[self.initialDataSourcesArray objectAtIndex:0]];
		[self.dataSourcesArray replaceObjectAtIndex:1 withObject:[self.initialDataSourcesArray objectAtIndex:1]];
	}
	
	tableView.dataSource = [self.dataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
	[self.tableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if (searchBar.text.length > 0) {
		[self.dataSourcesArray replaceObjectAtIndex:0 withObject:[self.initialDataSourcesArray objectAtIndex:0]];
		[self.dataSourcesArray replaceObjectAtIndex:1 withObject:[self.initialDataSourcesArray objectAtIndex:1]];
		self.tableView.dataSource = [self.initialDataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
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


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [self.dataSourcesArray objectAtIndex:item.tag];
	[self.tableView reloadData];
}


@end
