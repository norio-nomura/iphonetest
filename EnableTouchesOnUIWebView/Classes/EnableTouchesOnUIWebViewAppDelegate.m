//
//  EnableTouchesOnUIWebViewAppDelegate.m
//  EnableTouchesOnUIWebView
//

#import "EnableTouchesOnUIWebViewAppDelegate.h"
#import "EnableTouchesOnUIWebViewViewController.h"

@implementation EnableTouchesOnUIWebViewAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
