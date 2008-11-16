//
//  ClassBrowserAppDelegate.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserAppDelegate.h"
#import "ClassBrowserViewController.h"
#import "ClassTree.h"

@implementation ClassBrowserAppDelegate

@synthesize window;
@synthesize activityIndicatorView;
@synthesize navigationController;
@synthesize rootViewController;


- (void)dealloc {
	[rootViewController release];
	[navigationController release];
	[activityIndicatorView release];
	[window release];
	[super dealloc];
}


- (void)pushTree:(NSArray*)tree {
	[navigationController popToRootViewControllerAnimated:NO];
	for (NSString *className in tree) {
		ClassBrowserViewController *viewController = [[ClassBrowserViewController alloc] initWithNibName:@"ClassBrowserViewController" bundle:nil];
		viewController.title = className;
		[navigationController pushViewController:viewController animated:NO];
		[viewController release];
	}
	[tree release];
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[[ClassTree sharedClassTree] setupClassDictionary];
	[activityIndicatorView stopAnimating];
	rootViewController.title = KEY_ROOT_CLASSES;
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


@end
