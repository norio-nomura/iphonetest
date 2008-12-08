//
//  CameraTestAppDelegate.m
//  CameraTest
//

#import <objc/runtime.h>
#import "CameraTestAppDelegate.h"
#import "PLCameraController.h"


@implementation CameraTestAppDelegate

@synthesize window;
@synthesize cameraController;


- (IBAction)capturePhoto:(id)sender {
	[cameraController capturePhoto];
}


- (IBAction)tookPicture:(id)sender {
	char *p = (char *)cameraController->_camera;
	
//	CoreSurfaceAcceleratorRef accelerator = *(CoreSurfaceAcceleratorRef*)(p+84);

	CoreSurfaceBufferRef coreSurfaceBuffer = NULL;
	uint8_t* pixels = NULL;
	for (int i = 0; i<6; i++) {
		coreSurfaceBuffer = *(CoreSurfaceBufferRef*)(p+88+i*4);
		if (coreSurfaceBuffer) {
			CoreSurfaceBufferLock(coreSurfaceBuffer, 3);
			unsigned int surfaceId = CoreSurfaceBufferGetID(coreSurfaceBuffer);
			unsigned int width = CoreSurfaceBufferGetWidth(coreSurfaceBuffer);
			unsigned int height = CoreSurfaceBufferGetHeight(coreSurfaceBuffer);
			unsigned int bytesPerRow = CoreSurfaceBufferGetBytesPerRow(coreSurfaceBuffer);
			pixels = CoreSurfaceBufferGetBaseAddress(coreSurfaceBuffer);
			CoreSurfaceBufferUnlock(coreSurfaceBuffer);
			NSLog(@"CoreSurfaceBuffer#%d:0x%x,Id=0x%x,Pixels=0x%x",i,coreSurfaceBuffer,surfaceId,pixels);
			
			if (1) {	// write to pixels
				int w = width;
				int h = height;
				uint32_t *p = (uint32_t *)pixels;
				static int frameIndex = 0;
				for (int y = 0; y < h; y++) {
					for (int x = 0; x < w; x++) {
						int r = (x + y + frameIndex * 1) & 0xff;
						int g = (x + y + frameIndex * 7) & 0xff;
						int b = (x + y + frameIndex * 23) & 0xff;
						*p = (b << 24) | (g << 16) | (r<<8);
						p++;
					}
				}
				frameIndex++;
			}
 			
			// create the bitmap context
			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, pixels,
																			 height * bytesPerRow,
																			 NULL);
			
			CGImageRef imageRef 
			= CGImageCreate(width,					// size_t width,
							height,					// size_t height,
							8,						// size_t bitsPerComponent,
							32,						// size_t bitsPerPixel,
							bytesPerRow,			// size_t bytesPerRow,
							colorSpace,				// CGColorSpaceRef colorspace,
							(kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst),	// CGBitmapInfo bitmapInfo,
							dataProviderRef,		// CGDataProviderRef provider,
							NULL,					// const CGFloat decode[],
							NO,						// bool shouldInterpolate,
							kCGRenderingIntentDefault	// CGColorRenderingIntent intent
							);
			
			UIImage *image = [UIImage imageWithCGImage:imageRef];
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *fileName = [NSString stringWithFormat:@"coreSurface-%d.png",i];
			NSString *pathToDefault = [documentsDirectory stringByAppendingPathComponent:fileName];
			
			NSData *data = UIImagePNGRepresentation(image);
			[data writeToFile:pathToDefault atomically:NO];
			
			CGImageRelease(imageRef);
			CGDataProviderRelease(dataProviderRef);
			CGColorSpaceRelease(colorSpace);
		}
	}
}


- (void)dealloc {
    [window release];
	[cameraController release];
    [super dealloc];
}


#pragma mark PLCameraControllerDelegate


-(void)cameraController:(id)sender tookPicture:(UIImage*)picture withPreview:(UIImage*)preview jpegData:(NSData*)jpeg imageProperties:(NSDictionary *)exif {
	NSLog(@"you can get UIImage here. rotate is needed.");
	NSLog(@"picture.size:%f,%f",picture.size.width,picture.size.height);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathToDefault = [documentsDirectory stringByAppendingPathComponent:@"Default.png"];
	
	NSData *data = UIImagePNGRepresentation(preview);
	[data writeToFile:pathToDefault atomically:NO];
}


- (void)cameraControllerReadyStateChanged:(id)fp8{
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	application.statusBarHidden = YES;
	self.cameraController = [PLCameraController sharedInstance];
	[cameraController setDelegate:self];
	UIView *previewView = [cameraController previewView];
	[cameraController startPreview];
	[window addSubview:previewView];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
