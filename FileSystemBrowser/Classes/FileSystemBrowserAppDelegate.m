//
//  FileSystemBrowserAppDelegate.m
//  FileSystemBrowser
//

#import "FileSystemBrowserAppDelegate.h"
#import "FileSystemViewController.h"


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


- (void)pushFileSystemViewControllerWithPath:(NSString*)path {
	FileSystemViewController *viewController = [[FileSystemViewController alloc] initWithNibName:NSStringFromClass([FileSystemViewController class]) bundle:nil];
	viewController.path = path;
	[navigationController pushViewController:viewController animated:YES];
	[viewController release];
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
