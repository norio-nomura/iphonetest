//
//  ClassBrowserAppDelegate.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>

@class ClassBrowserViewController;

@interface ClassBrowserAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIView *splashView;
	UIActivityIndicatorView *activityIndicatorView;
    UINavigationController *navigationController;
	ClassBrowserViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *splashView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ClassBrowserViewController *rootViewController;

- (void)pushClass:(NSString*)className;
- (void)pushClassTree:(NSArray*)classTree;

@end
