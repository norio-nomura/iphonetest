//
//  ClassBrowserViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserAppDelegate.h"
#import "ClassBrowserViewController.h"
#import "ClassSearchViewController.h"
#import "ClassTree.h"
#import "IndexedDataSource.h"
#import "SubclassesDataSource.h"


#define KEY_SUBCLASSES			@"Subclasses"
#define KEY_PROPERTIES			@"Properties"
#define KEY_CLASS_METHODS		@"ClassMethods"
#define KEY_INSTANCE_METHODS	@"InstanceMethods"
#define KEY_PROTOCOLS			@"Protocols"


@implementation ClassBrowserViewController

@synthesize tableView;
@synthesize tabBar;
@synthesize classSearchButtonItem;
@synthesize dataSourcesArray = dataSourcesArray_;


- (void)dealloc {
	[tableView release];
	[tabBar release];
	[classSearchButtonItem release];
	[dataSourcesArray_ release];
    [super dealloc];
}


- (void)loadDataSources {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
	NSMutableArray *tempArray;
	IndexedDataSource *indexedDataSource;
	NSUInteger index = 0;
	
	// Subclasses
	if ([[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] count] > 0) {
		indexedDataSource = [[SubclassesDataSource alloc] initWithArray:[[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] allKeys]];
		indexedDataSource.name = KEY_SUBCLASSES;
		[array addObject:indexedDataSource];
		[indexedDataSource release];
		[[tabBar.items objectAtIndex:index++] setTag:[array count]-1];
	} else {
		[[tabBar.items objectAtIndex:index++] setEnabled:NO];
	}
	
	Class class = objc_getClass([self.title cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		// Properties
		unsigned int outCount;
		objc_property_t *properties = class_copyPropertyList(class, &outCount);
		if (outCount) {
			tempArray = [NSMutableArray arrayWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				[tempArray addObject:[NSString stringWithFormat:@"%s(%s)", 
									  property_getName(properties[i]), 
									  property_getAttributes(properties[i])]];
			}
			free(properties);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:tempArray];
			indexedDataSource.name = KEY_PROPERTIES;
			[array addObject:indexedDataSource];
			[indexedDataSource release];
			[[tabBar.items objectAtIndex:index++] setTag:[array count]-1];
		} else {
			[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		}
		// Class Methods
		Method *classMethods = class_copyMethodList(object_getClass(class), &outCount);
		if (outCount) {
			tempArray = [NSMutableArray arrayWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				[tempArray addObject:[NSString stringWithFormat:@"%s(%s)", 
									  sel_getName(method_getName(classMethods[i])), 
									  method_getTypeEncoding(classMethods[i])]];
			}
			free(classMethods);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:tempArray];
			indexedDataSource.name = KEY_CLASS_METHODS;
			[array addObject:indexedDataSource];
			[indexedDataSource release];
			[[tabBar.items objectAtIndex:index++] setTag:[array count]-1];
		} else {
			[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		}
		// Instance Methods
		Method *instanceMethods = class_copyMethodList(class, &outCount);
		if (outCount) {
			tempArray = [NSMutableArray arrayWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				[tempArray addObject:[NSString stringWithFormat:@"%s(%s)", 
									  sel_getName(method_getName(instanceMethods[i])), 
									  method_getTypeEncoding(instanceMethods[i])]];
			}
			free(instanceMethods);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:tempArray];
			indexedDataSource.name = KEY_INSTANCE_METHODS;
			[array addObject:indexedDataSource];
			[indexedDataSource release];
			[[tabBar.items objectAtIndex:index++] setTag:[array count]-1];
		} else {
			[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		}
		Protocol **protocols = class_copyProtocolList(class, &outCount);
		if (outCount) {
			tempArray = [NSMutableArray arrayWithCapacity:outCount];
			for (unsigned int i = 0; i < outCount; i++) {
				[tempArray addObject:[NSString stringWithFormat:@"%s", 
									  protocol_getName(protocols[i])]];
			}
			free(protocols);
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:tempArray];
			indexedDataSource.name = KEY_PROTOCOLS;
			[array addObject:indexedDataSource];
			[indexedDataSource release];
			[[tabBar.items objectAtIndex:index++] setTag:[array count]-1];
		} else {
			[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		}
	} else {
		[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		[[tabBar.items objectAtIndex:index++] setEnabled:NO];
		[[tabBar.items objectAtIndex:index++] setEnabled:NO];
	}
	
	dataSourcesArray_ = [[NSArray alloc] initWithArray:array];
	
	for (UITabBarItem* item in tabBar.items) {
		if (item.enabled) {
			tabBar.selectedItem = item;
			tableView.dataSource = [dataSourcesArray_ objectAtIndex:item.tag];
			break;
		}
	}
	
	[tableView reloadData];
}


- (IBAction)showClassSearch:(id)sender {
	if (![[[self.navigationController topViewController] class] isMemberOfClass:[ClassSearchViewController class]]) {
		ClassSearchViewController *viewController = [[ClassSearchViewController alloc] initWithNibName:@"ClassSearchViewController" bundle:nil];
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
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
	if ([[(IndexedDataSource*)self.tableView.dataSource name] isEqual:KEY_SUBCLASSES]) {
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate pushClass:[[(IndexedDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath] description]];
	} else if ([[(IndexedDataSource*)self.tableView.dataSource name] isEqual:KEY_CLASS_METHODS]) {
//		Class class = objc_getClass(self.title);
//		Method 
	}
}


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [self.dataSourcesArray objectAtIndex:item.tag];
	[self.tableView reloadData];
}


@end
