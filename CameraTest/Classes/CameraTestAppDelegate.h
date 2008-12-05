//
//  CameraTestAppDelegate.h
//  CameraTest
//

#import <UIKit/UIKit.h>

@interface CameraTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	id cameraController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) id cameraController;

- (IBAction)capturePhoto:(id)sender;

@end

