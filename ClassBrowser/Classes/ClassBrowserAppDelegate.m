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
@synthesize splashView;
@synthesize activityIndicatorView;
@synthesize navigationController;
@synthesize rootViewController;


- (void)dealloc {
	[rootViewController release];
	[navigationController release];
	[activityIndicatorView release];
	[splashView release];
	[window release];
	[super dealloc];
}


#define kANIMATION_DELAY_SECOND 1


- (void)splashAnimation {
	[[ClassTree sharedClassTree] setupClassDictionary];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kANIMATION_DELAY_SECOND];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
	[activityIndicatorView stopAnimating];
	[splashView removeFromSuperview];
	rootViewController.title = KEY_ROOT_CLASSES;
	[window addSubview:[navigationController view]];
	[UIView commitAnimations];
}


- (void)pushClass:(NSString*)className {
	ClassBrowserViewController *viewController = [[ClassBrowserViewController alloc] initWithNibName:@"ClassBrowserViewController" bundle:nil];
	viewController.title = className;
	[navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


- (void)pushClassTree:(NSArray*)classTree {
	[navigationController popToRootViewControllerAnimated:YES];
	int i = 1;
	for (NSString *className in classTree) {
		[self performSelector:@selector(pushClass:) withObject:className afterDelay:i++];
	}
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window makeKeyAndVisible];
	[self performSelector:@selector(splashAnimation) withObject:nil afterDelay:0.1];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


@end
