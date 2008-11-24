//
//  ClassBrowserViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserViewController.h"
#import "ClassBrowserAppDelegate.h"
#import "ClassSearchViewController.h"
#import "ClassTree.h"
#import "IndexedDataSource.h"
#import "SubclassesDataSource.h"

@implementation ClassBrowserViewController

@synthesize tableView;
@synthesize tabBar;
@synthesize itemSubclasses;
@synthesize itemProperties;
@synthesize itemClassMethods;
@synthesize itemInstanceMethods;
@synthesize itemProtocols;
@synthesize classSearchButtonItem;
@synthesize dataSourcesArray;


- (void)dealloc {
	[tableView release];
	[tabBar release];
	[itemSubclasses release];
	[itemProperties release];
	[itemClassMethods release];
	[itemInstanceMethods release];
	[itemProtocols release];
	[classSearchButtonItem release];
	[dataSourcesArray release];
    [super dealloc];
}


- (void)loadDataSources {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
	self.dataSourcesArray = array;
	[array release];
	
	IndexedDataSource *indexedDataSource;
	
	// Subclasses
	if ([[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] count] > 0) {
		indexedDataSource = [[SubclassesDataSource alloc] initWithArray:[[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] allKeys]];
		[dataSourcesArray addObject:indexedDataSource];
		[indexedDataSource release];
		itemSubclasses.tag = [dataSourcesArray count] - 1;
	} else {
		itemSubclasses.enabled = NO;
	}
	
	Class class = objc_getClass([self.title cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		unsigned int outCount;
		// Properties
		objc_property_t *properties = class_copyPropertyList(class, &outCount);
		if (outCount) {
			array = [[NSMutableArray alloc] initWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				NSString *propertyString = [[NSString alloc] initWithFormat:@"%s\n    (%s)", 
											property_getName(properties[i]), 
											property_getAttributes(properties[i])];
				[array addObject:propertyString];
				[propertyString release];
			}
			free(properties);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemProperties.tag = [dataSourcesArray count] - 1;
		} else {
			itemProperties.enabled = NO;
		}
		// Class Methods
		Method *classMethods = class_copyMethodList(object_getClass(class), &outCount);
		if (outCount) {
			array = [[NSMutableArray alloc] initWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				NSString *classMethodString = [[NSString alloc] initWithFormat:@"%s\n    (%s)", 
											   sel_getName(method_getName(classMethods[i])), 
											   method_getTypeEncoding(classMethods[i])];
				[array addObject:classMethodString];
				[classMethodString release];
			}
			free(classMethods);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemClassMethods.tag = [dataSourcesArray count] - 1;
		} else {
			itemClassMethods.enabled = NO;
		}
		// Instance Methods
		Method *instanceMethods = class_copyMethodList(class, &outCount);
		if (outCount) {
			array = [[NSMutableArray alloc] initWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				NSString *instanceMethodString = [[NSString alloc] initWithFormat:@"%s\n    (%s)", 
												  sel_getName(method_getName(instanceMethods[i])), 
												  method_getTypeEncoding(instanceMethods[i])];
				[array addObject:instanceMethodString];
				[instanceMethodString release];
			}
			free(instanceMethods);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemInstanceMethods.tag = [dataSourcesArray count] - 1;
		} else {
			itemInstanceMethods.enabled = NO;
		}
		// Protocols
		Protocol **protocols = class_copyProtocolList(class, &outCount);
		if (outCount) {
			array = [[NSMutableArray alloc] initWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				NSString *protocolString = [[NSString alloc] initWithFormat:@"%s", 
											protocol_getName(protocols[i])];
				[array addObject:protocolString];
				[protocolString release];
			}
			free(protocols);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemProtocols.tag = [dataSourcesArray count] - 1;
		} else {
			itemProtocols.enabled = NO;
		}
	} else {
		itemProperties.enabled = NO;
		itemClassMethods.enabled = NO;
		itemInstanceMethods.enabled = NO;
		itemProtocols.enabled = NO;
	}
	
	for (UITabBarItem* item in tabBar.items) {
		if (item.enabled) {
			tabBar.selectedItem = item;
			tableView.dataSource = [dataSourcesArray objectAtIndex:item.tag];
			break;
		}
	}
	
	[tableView reloadData];
}


#pragma mark Public method


- (IBAction)showClassSearch:(id)sender {
	if (![[[self.navigationController topViewController] class] isMemberOfClass:[ClassSearchViewController class]]) {
		ClassSearchViewController *viewController = [[ClassSearchViewController alloc] initWithNibName:@"ClassSearchViewController" bundle:nil];
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}


- (void)selectSubclassRow:(NSString*)className {
	if (itemSubclasses.enabled) {
		if (![tabBar.selectedItem isEqual:itemSubclasses]) {
			tabBar.selectedItem = itemSubclasses;
			tableView.dataSource = [dataSourcesArray objectAtIndex:itemSubclasses.tag];
			[tableView reloadData];
		}
		IndexedDataSource *currentDataSource = [dataSourcesArray objectAtIndex:itemSubclasses.tag];
		if (currentDataSource) {
			NSIndexPath *indexPath = [currentDataSource indexPathForObject:className];
			if (indexPath) {
				[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
			}
		}
	}
}


#pragma mark UIViewController Class


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = classSearchButtonItem;
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
	if ([tabBar.selectedItem isEqual:itemSubclasses]) {
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate pushClass:[[[dataSourcesArray objectAtIndex:itemSubclasses.tag] objectForRowAtIndexPath:indexPath] description]];
	} else if ([tabBar.selectedItem isEqual:itemProtocols]) {
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate pushProtocol:[[[dataSourcesArray objectAtIndex:itemProtocols.tag] objectForRowAtIndexPath:indexPath] description]];
	}
}


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [dataSourcesArray objectAtIndex:item.tag];
	[tableView reloadData];
}


@end
