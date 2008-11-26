//
//  EmojiKeyboardEnablerAppDelegate.m
//  EmojiKeyboardEnabler
//

#import "EmojiKeyboardEnablerAppDelegate.h"
#import "EmojiKeyboardEnablerViewController.h"
#import "EmojiKeyboardEnabler.h"

@implementation EmojiKeyboardEnablerAppDelegate

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
