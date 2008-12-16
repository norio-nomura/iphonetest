//
//  FileSystemBrowserAppDelegate.m
//  FileSystemBrowser
//

#import "FileSystemBrowserAppDelegate.h"
#import "ContentsOfDirectoryViewController.h"
#import "PropertyListViewController.h"
#import "MachOFileSymbolsViewController.h"


@implementation FileSystemBrowserAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize rootViewController;


- (void)dealloc {
	[rootViewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark privateMethod


- (void)pushViewControllerWithPath:(NSString*)path {
	NSDictionary *attributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
	if ([[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
		ContentsOfDirectoryViewController *viewController = [[ContentsOfDirectoryViewController alloc] initWithNibName:NSStringFromClass([ContentsOfDirectoryViewController class]) bundle:nil];
		viewController.path = path;
		[navigationController pushViewController:viewController animated:YES];
		[viewController release];
	} else if ([[attributes objectForKey:NSFileType] isEqual:NSFileTypeRegular]) {
		if ([path hasSuffix:@".plist"]) {
			PropertyListViewController *viewController = [[PropertyListViewController alloc] initWithNibName:NSStringFromClass([PropertyListViewController class]) bundle:nil];
			viewController.path = path;
			[navigationController pushViewController:viewController animated:YES];
			[viewController release];
		} else {
			NSArray *symbols = MachOFileSymbolsCreate(path);
			if (symbols) {
				MachOFileSymbolsViewController *viewController = [[MachOFileSymbolsViewController alloc] initWithNibName:NSStringFromClass([MachOFileSymbolsViewController class]) bundle:nil];
				viewController.path = path;
				viewController.symbols = symbols;
				[symbols release];
				[navigationController pushViewController:viewController animated:YES];
				[viewController release];
			}
		}

	} else {
		for (id key in [attributes allKeys]) {
			NSLog(@"%@:%@",key,[attributes objectForKey:key]);
		}
	}
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	rootViewController.path = @"/";
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


@end
