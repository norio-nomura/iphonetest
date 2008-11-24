//
//  ProtocolBrowserViewController.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ProtocolBrowserViewController.h"
#import "ClassBrowserAppDelegate.h"
#import "IndexedDataSource.h"

@implementation ProtocolBrowserViewController

@synthesize tableView;
@synthesize tabBar;
@synthesize itemProtocols;
@synthesize itemProperties;
@synthesize itemRequiredMethods;
@synthesize itemOptionalMethods;
@synthesize dataSourcesArray;


- (void)dealloc {
	[tableView release];
	[tabBar release];
	[itemProtocols release];
	[itemProperties release];
	[itemRequiredMethods release];
	[itemOptionalMethods release];
	[dataSourcesArray release];
    [super dealloc];
}


- (void)loadDataSources {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
	self.dataSourcesArray = array;
	[array release];
	
	IndexedDataSource *indexedDataSource;
	
	Protocol *protocol = objc_getProtocol([self.title cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (protocol) {
		unsigned int outCount;
		// Protocols
		Protocol **protocols = protocol_copyProtocolList(protocol, &outCount);
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
		// Properties
		objc_property_t *properties = protocol_copyPropertyList(protocol, &outCount);
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
		// Required Methods
		unsigned int classMethodsCount, instanceMethodsCount;
		struct objc_method_description *classMethods, *instanceMethods;
		classMethods = protocol_copyMethodDescriptionList(protocol, YES, NO, &classMethodsCount);
		instanceMethods = protocol_copyMethodDescriptionList(protocol, YES, YES, &instanceMethodsCount);
		if (classMethodsCount || instanceMethodsCount) {
			array = [[NSMutableArray alloc] initWithCapacity:classMethodsCount + instanceMethodsCount];
			for (unsigned int i = 0; i < classMethodsCount; i++) {
				NSString *classMethodString = [[NSString alloc] initWithFormat:@"+%s\n    (%s)", 
											   sel_getName(classMethods[i].name), 
											   classMethods[i].types];
				[array addObject:classMethodString];
				[classMethodString release];
			}
			if (classMethodsCount) {
				free(classMethods);
			}
			for (unsigned int i = 0; i < instanceMethodsCount; i++) {
				NSString *instanceMethodString = [[NSString alloc] initWithFormat:@"-%s\n    (%s)", 
												  sel_getName(instanceMethods[i].name), 
												  instanceMethods[i].types];
				[array addObject:instanceMethodString];
				[instanceMethodString release];
			}
			if (instanceMethodsCount) {
				free(instanceMethods);
			}
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemRequiredMethods.tag = [dataSourcesArray count] - 1;
		} else {
			itemRequiredMethods.enabled = NO;
		}
		// Optional Methods
		classMethods = protocol_copyMethodDescriptionList(protocol, NO, NO, &classMethodsCount);
		instanceMethods = protocol_copyMethodDescriptionList(protocol, NO, YES, &instanceMethodsCount);
		if (classMethodsCount || instanceMethodsCount) {
			array = [[NSMutableArray alloc] initWithCapacity:classMethodsCount + instanceMethodsCount];
			for (unsigned int i = 0; i < classMethodsCount; i++) {
				NSString *classMethodString = [[NSString alloc] initWithFormat:@"+%s\n    (%s)", 
											   sel_getName(classMethods[i].name), 
											   classMethods[i].types];
				[array addObject:classMethodString];
				[classMethodString release];
			}
			if (classMethodsCount) {
				free(classMethods);
			}
			for (unsigned int i = 0; i < instanceMethodsCount; i++) {
				NSString *instanceMethodString = [[NSString alloc] initWithFormat:@"-%s\n    (%s)", 
												  sel_getName(instanceMethods[i].name), 
												  instanceMethods[i].types];
				[array addObject:instanceMethodString];
				[instanceMethodString release];
			}
			if (instanceMethodsCount) {
				free(instanceMethods);
			}
			indexedDataSource = [[IndexedDataSource alloc] initWithArray:array];
			[array release];
			[dataSourcesArray addObject:indexedDataSource];
			[indexedDataSource release];
			itemOptionalMethods.tag = [dataSourcesArray count] - 1;
		} else {
			itemOptionalMethods.enabled = NO;
		}
	} else {
		itemProtocols.enabled = NO;
		itemProperties.enabled = NO;
		itemRequiredMethods.enabled = NO;
		itemOptionalMethods.enabled = NO;
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


#pragma mark UIViewController Class


- (void)viewDidLoad {
    [super viewDidLoad];
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
	if ([tabBar.selectedItem isEqual:itemProtocols]) {
		ClassBrowserAppDelegate *appDelegate = (ClassBrowserAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate pushClass:[[[dataSourcesArray objectAtIndex:itemProtocols.tag] objectForRowAtIndexPath:indexPath] description]];
	}
}


#pragma mark UITabBarDelegate Protocol


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	tableView.dataSource = [dataSourcesArray objectAtIndex:item.tag];
	[tableView reloadData];
}


@end
