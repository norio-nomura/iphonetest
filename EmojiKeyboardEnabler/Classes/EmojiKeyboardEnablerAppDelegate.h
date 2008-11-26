//
//  EmojiKeyboardEnablerAppDelegate.h
//  EmojiKeyboardEnabler
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

