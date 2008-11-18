//
//  ClassBrowserAppDelegate.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "ClassBrowserAppDelegate.h"
#import "ClassBrowserViewController.h"
#import "ClassTree.h"
#import "IndexedDataSource.h"

@implementation ClassBrowserAppDelegate

@synthesize window;
@synthesize splashView;
@synthesize activityIndicatorView;
@synthesize navigationController;
@synthesize rootViewController;
@synthesize autoPushClassNames;


- (void)dealloc {
	[autoPushClassNames release];
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


- (void)pushClassTree:(NSMutableArray*)classTree {
	self.autoPushClassNames = classTree;
	[navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window makeKeyAndVisible];
	[self performSelector:@selector(splashAnimation) withObject:nil afterDelay:0.1];
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
			IndexedDataSource *dataSource = (IndexedDataSource*)prevViewController.tableView.dataSource;
			NSIndexPath *indexPath = [dataSource indexPathForObject:viewController.title];
			if (indexPath) {
				[prevViewController.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
			}
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
