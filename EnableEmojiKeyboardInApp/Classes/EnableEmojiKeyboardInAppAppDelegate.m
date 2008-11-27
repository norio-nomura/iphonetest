//
//  EnableEmojiKeyboardInAppAppDelegate.m
//  EnableEmojiKeyboardInApp
//

#import "EnableEmojiKeyboardInAppAppDelegate.h"
#import "EnableEmojiKeyboardInAppViewController.h"
#import "EmojiKeyboardEnabler.h"


@implementation EnableEmojiKeyboardInAppAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    installEmojiKeyboardEnabler();
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
