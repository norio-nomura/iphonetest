//
//  EmojiKeyboardEnablerAppDelegate.h
//  EmojiKeyboardEnabler
//
//  Created by 野村 憲男 on 08/11/26.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmojiKeyboardEnablerViewController;

@interface EmojiKeyboardEnablerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EmojiKeyboardEnablerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EmojiKeyboardEnablerViewController *viewController;

@end

