//
//  EnableEmojiKeyboardInAppAppDelegate.h
//  EnableEmojiKeyboardInApp
//

#import <UIKit/UIKit.h>

@class EnableEmojiKeyboardInAppViewController;

@interface EnableEmojiKeyboardInAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EnableEmojiKeyboardInAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EnableEmojiKeyboardInAppViewController *viewController;

@end

