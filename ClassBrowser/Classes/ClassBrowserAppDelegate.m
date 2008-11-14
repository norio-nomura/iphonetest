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
@synthesize navigationController;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	rootViewController.title = KEY_ROOT_CLASSES;

    [window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[rootViewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
