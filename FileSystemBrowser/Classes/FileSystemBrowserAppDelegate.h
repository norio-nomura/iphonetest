//
//  FileSystemBrowserAppDelegate.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>
#import "ContentsOfDirectoryViewController.h"

@interface FileSystemBrowserAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	ContentsOfDirectoryViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ContentsOfDirectoryViewController *rootViewController;

- (void)pushViewControllerWithPath:(NSString*)path;

@end

