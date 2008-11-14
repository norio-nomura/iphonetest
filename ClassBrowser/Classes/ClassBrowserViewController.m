//
//  ClassBrowserViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserViewController.h"
#import "ClassTree.h"
#import "ClassDataSource.h"

@implementation ClassBrowserViewController

@synthesize tableView;
@synthesize tabBar;
@synthesize dataSourcesArray = dataSourcesArray_;


- (void)dealloc {
	[tableView release];
	[tabBar release];
	[dataSourcesArray_ release];
    [super dealloc];
}


#pragma mark UIViewController Class


- (void)viewDidLoad {
	[super viewDidLoad];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
	NSMutableArray *tempArray;
	ClassDataSource *classDataSource;
	NSUInteger index = 0;
	
	// Subclasses
	if ([[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] count] > 0) {
		classDataSource = [[ClassDataSource alloc] initWithArray:[[[ClassTree sharedClassTree].classDictionary objectForKey:self.title] allKeys]];
		[array addObject:classDataSource];
		[classDataSource release];
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
			classDataSource = [[ClassDataSource alloc] initWithArray:tempArray];
			[array addObject:classDataSource];
			[classDataSource release];
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
			classDataSource = [[ClassDataSource alloc] initWithArray:tempArray];
			[array addObject:classDataSource];
			[classDataSource release];
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
			classDataSource = [[ClassDataSource alloc] initWithArray:tempArray];
			[array addObject:classDataSource];
			[classDataSource release];
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
			classDataSource = [[ClassDataSource alloc] initWithArray:tempArray];
			[array addObject:classDataSource];
			[classDataSource release];
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
	if ([tabBar.selectedItem.title isEqual:@"SubCls"]) {
		ClassBrowserViewController *viewController = [[ClassBrowserViewController alloc] initWithNibName:@"ClassBrowserViewController" bundle:nil];
		viewController.title = [(ClassDataSource*)self.tableView.dataSource objectForRowAtIndexPath:indexPath];
		[[self navigationController] pushViewController:viewController animated:YES];
		[viewController release];
	}
}


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [self.dataSourcesArray objectAtIndex:item.tag];
	[self.tableView reloadData];
}


@end
