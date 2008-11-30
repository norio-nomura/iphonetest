//
//  FileSystemBrowserAppDelegate.m
//  FileSystemBrowser
//

#import "FileSystemBrowserAppDelegate.h"
#import "FileSystemViewController.h"
#import "PropertyListViewController.h"


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
		FileSystemViewController *viewController = [[FileSystemViewController alloc] initWithNibName:NSStringFromClass([FileSystemViewController class]) bundle:nil];
		viewController.path = path;
		[navigationController pushViewController:viewController animated:YES];
		[viewController release];
	} else if ([[attributes objectForKey:NSFileType] isEqual:NSFileTypeRegular]) {
		if ([path hasSuffix:@".plist"]) {
			PropertyListViewController *viewController = [[PropertyListViewController alloc] initWithNibName:NSStringFromClass([PropertyListViewController class]) bundle:nil];
			viewController.path = path;
			[navigationController pushViewController:viewController animated:YES];
			[viewController release];
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
