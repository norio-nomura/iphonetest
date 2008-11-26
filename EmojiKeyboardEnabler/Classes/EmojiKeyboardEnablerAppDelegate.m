//
//  EmojiKeyboardEnablerAppDelegate.m
//  EmojiKeyboardEnabler
//
//  Created by 野村 憲男 on 08/11/26.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
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
