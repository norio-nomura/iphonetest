//
//  CameraTestAppDelegate.h
//  CameraTest
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import "PLCameraController.h"
#import "CoreSurface.h"

@interface CameraTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	PLCameraController *cameraController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PLCameraController *cameraController;


- (IBAction)capturePhoto:(id)sender;
- (IBAction)tookPicture:(id)sender;

@end

