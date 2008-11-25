//
//  ClassBrowserAppDelegate.m
//  ClassBrowser
//

#import "ClassBrowserAppDelegate.h"
#import "ProtocolBrowserViewController.h"
#import "ClassTree.h"

@interface ClassBrowserAppDelegate(private)
- (void)pushViewController:(Class)class withTitle:(NSString*)title;
@end

@implementation ClassBrowserAppDelegate

@synthesize window;
@synthesize splashView;
@synthesize activityIndicatorView;
@synthesize navigationController;
@synthesize rootViewController;
@synthesize autoPushClassNames;


- (void)dealloc {
	[window release];
	[splashView release];
	[activityIndicatorView release];
	[navigationController release];
	[rootViewController release];
	[autoPushClassNames release];
	[super dealloc];
}


#define kANIMATION_DELAY_SECOND 1


- (void)pushClass:(NSString*)className {
	[self pushViewController:[ClassBrowserViewController class] withTitle:className];
}


- (void)pushProtocol:(NSString*)protocolName {
	[self pushViewController:[ProtocolBrowserViewController class] withTitle:protocolName];
}


#pragma mark privateMethod


- (void)pushViewController:(Class)class withTitle:(NSString*)title {
	if ([class isSubclassOfClass:[UIViewController class]]) {
		UIViewController *viewController = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
		viewController.title = title;
		[navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}


- (void)splashAnimation {
	[[ClassTree sharedClassTree] loadAllFrameworks];
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


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window makeKeyAndVisible];
	[self performSelector:@selector(splashAnimation) withObject:nil afterDelay:0.01];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark UINavigationControllerDelegate 


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (self.autoPushClassNames) {
		NSUInteger index = [self.navigationController.viewControllers indexOfObject:viewController];
		if (index && index != NSNotFound) {
			ClassBrowserViewController *prevViewController = (ClassBrowserViewController*)[self.navigationController.viewControllers objectAtIndex:index-1];
			[prevViewController selectSubclassRow:viewController.title];
		}
		if ([self.autoPushClassNames count] == 0) {
			self.autoPushClassNames = nil;
		}
	}
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (self.autoPushClassNames) {
		[self performSelector:@selector(pushClass:) withObject:[self.autoPushClassNames lastObject] afterDelay:0.1];
		[self.autoPushClassNames removeLastObject];
	}
}


@end
