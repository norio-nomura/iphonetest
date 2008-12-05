//
//  CameraTestAppDelegate.m
//  CameraTest
//

#import <objc/runtime.h>
#import "CameraTestAppDelegate.h"

@implementation CameraTestAppDelegate

@synthesize window;
@synthesize cameraController;


- (void)dealloc {
    [window release];
	[cameraController release];
    [super dealloc];
}


#pragma mark PLCameraControllerDelegattttttt


- (IBAction)capturePhoto:(id)sender {
	[cameraController capturePhoto];
}


-(void)cameraController:(id)sender tookPicture:(UIImage*)picture withPreview:(UIImage*)preview jpegData:(NSData*)jpeg imageProperties:(NSDictionary *)exif {
	NSLog(@"you can get UIImage here");
}


- (void)cameraControllerReadyStateChanged:(id)fp8{
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	application.statusBarHidden = YES;
	
	self.cameraController = [objc_getClass("PLCameraController") sharedInstance];
	[cameraController setDelegate:self];
	UIView *previewView = [cameraController previewView];
	[cameraController startPreview];
	[window addSubview:previewView];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
