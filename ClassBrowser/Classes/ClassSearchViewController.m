//
//  ClassSearchViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassSearchViewController.h"
#import "ClassBrowserAppDelegate.h"
#import "ClassTree.h"
#import "SubclassesDataSource.h"
#import "SubclassesWithImageSectionsDataSource.h"

@implementation ClassSearchViewController

@synthesize tableView;
@synthesize segmentedControl;
@synthesize searchBar;
@synthesize tabBar;
@synthesize dataSourcesArray;
@synthesize initialDataSourcesArray;
@synthesize previousSearchText;


- (void)dealloc {
	[tableView release];
	[segmentedControl release];
	[searchBar release];
	[tabBar release];
	[dataSourcesArray release];
	[initialDataSourcesArray release];
	[previousSearchText release];
    [super dealloc];
}


- (void)loadDataSources {
	NSUInteger tag = 0;
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
	self.dataSourcesArray = array;
	[array release];
	array = [[NSMutableArray alloc] initWithCapacity:2];
	self.initialDataSourcesArray = array;
	[array release];
	
	[dataSourcesArray addObject:[ClassTree sharedClassTree].subclassesDataSource];
	[initialDataSourcesArray addObject:[ClassTree sharedClassTree].subclassesDataSource];
	[[tabBar.items objectAtIndex:[dataSourcesArray count] - 1] setTag:tag++];
	
	[dataSourcesArray addObject:[ClassTree sharedClassTree].subclassesWithImageSectionsDataSource];
	[initialDataSourcesArray addObject:[ClassTree sharedClassTree].subclassesWithImageSectionsDataSource];
	[[tabBar.items objectAtIndex:[dataSourcesArray count] - 1] setTag:tag++];
	
	tabBar.selectedItem = [tabBar.items objectAtIndex:0];
	tableView.dataSource = [dataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
	[tableView reloadData];
}	


#pragma mark UIViewController Class


- (void)viewDidLoad {
    [super viewDidLoad];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[self loadDataSources];
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
		[appDelegate pushClass:[[[dataSourcesArray objectAtIndex:tabBar.selectedItem.tag] objectForRowAtIndexPath:indexPath] description]];
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		NSString *className = [[[dataSourcesArray objectAtIndex:tabBar.selectedItem.tag] objectForRowAtIndexPath:indexPath] description];
		NSMutableArray *classNameArray = [[NSMutableArray alloc] initWithObjects:className,nil];
		const char *superClassName = class_getName(class_getSuperclass(objc_getClass([className cStringUsingEncoding:NSNEXTSTEPStringEncoding])));
		/*
		 Based on "Objective-C 2.0 Runtime Reference", superClassName become empty string when superClassName reached rootclasses.
		 So condition will,
		 > while (strlen(superClassName)) {
		 But current class_getName return "nil"
		 */
		while (strcmp(superClassName,"nil")) {
			className = [[NSString alloc] initWithCString:superClassName encoding:NSNEXTSTEPStringEncoding];
			[classNameArray addObject:className];
			[className release];
			superClassName = class_getName(class_getSuperclass(objc_getClass(superClassName)));
		}
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.autoPushClassNames = classNameArray;
		[classNameArray release];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [dataSourcesArray objectAtIndex:item.tag];
	[tableView reloadData];
}


#pragma mark UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchText.length > 0) {
		// from subclassesDataSource
		SubclassesDataSource *currentSubclassesDataSource;
		if (previousSearchText && [searchText hasPrefix:previousSearchText]) {
			currentSubclassesDataSource = [dataSourcesArray objectAtIndex:0];
		} else {
			currentSubclassesDataSource = [initialDataSourcesArray objectAtIndex:0];
		}
		self.previousSearchText = searchText;
		NSArray *classNamesArray = [[currentSubclassesDataSource.rows objectForKey:[searchText capitalChar]] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:[classNamesArray count]];
		for (NSString *className in classNamesArray) {
			NSComparisonResult result = [className compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)];
			if (result == NSOrderedSame) {
				[filteredArray addObject:className];
			} else if (result == NSOrderedDescending) {
				break;
			}
		}
		SubclassesDataSource * subclassesDataSource = [[SubclassesDataSource alloc] initWithArray:filteredArray];
		[dataSourcesArray replaceObjectAtIndex:0 withObject:subclassesDataSource];
		[subclassesDataSource release];
		SubclassesWithImageSectionsDataSource *subclassesWithImageSectionsDataSource = [[SubclassesWithImageSectionsDataSource alloc] initWithArray:filteredArray];
		[dataSourcesArray replaceObjectAtIndex:1 withObject:subclassesWithImageSectionsDataSource];
		[subclassesWithImageSectionsDataSource release];
	} else {
		[dataSourcesArray replaceObjectAtIndex:0 withObject:[initialDataSourcesArray objectAtIndex:0]];
		[dataSourcesArray replaceObjectAtIndex:1 withObject:[initialDataSourcesArray objectAtIndex:1]];
	}
	
	tableView.dataSource = [dataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
	[tableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if (self.searchBar.text.length > 0) {
		[dataSourcesArray replaceObjectAtIndex:0 withObject:[initialDataSourcesArray objectAtIndex:0]];
		[dataSourcesArray replaceObjectAtIndex:1 withObject:[initialDataSourcesArray objectAtIndex:1]];
		tableView.dataSource = [initialDataSourcesArray objectAtIndex:tabBar.selectedItem.tag];
	}
	
	[tableView reloadData];
	
	[self.searchBar resignFirstResponder];
	self.searchBar.text = @"";
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	self.searchBar.showsCancelButton = YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	self.searchBar.showsCancelButton = NO;
}


@end
