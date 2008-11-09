//
//  EnableTouchesOnUIWebViewAppDelegate.h
//  EnableTouchesOnUIWebView
//

#import <UIKit/UIKit.h>

@class EnableTouchesOnUIWebViewViewController;

@interface EnableTouchesOnUIWebViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EnableTouchesOnUIWebViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EnableTouchesOnUIWebViewViewController *viewController;

@end

