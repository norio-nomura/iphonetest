//
//  FileSystemBrowserAppDelegate.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>
#import "FileSystemViewController.h"

@interface FileSystemBrowserAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	FileSystemViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet FileSystemViewController *rootViewController;

- (void)pushFileSystemViewControllerWithPath:(NSString*)path;

@end

