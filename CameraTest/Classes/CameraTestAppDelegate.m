//
//  CameraTestAppDelegate.m
//  CameraTest
//

#import <objc/runtime.h>
#import "CameraTestAppDelegate.h"
#import "CoreSurface.h"

OBJC_EXPORT unsigned int CGBitmapGetFastestAlignment();
OBJC_EXPORT void * CGBitmapAllocateData(unsigned int);
OBJC_EXPORT void CGBitmapFreeData(const void *data);

typedef void (*FUNC_camera_callback)(void *struct_CameraDevice,int,CoreSurfaceBufferRef,int);

static FUNC_camera_callback original_camera_callback = NULL;
static void *readblePixels = NULL;

static void __camera_callbackHook(void *cameraDevice,int a,CoreSurfaceBufferRef surface,int b) {
	if (surface) {
		CoreSurfaceBufferLock(surface, 3);
		unsigned int height = CoreSurfaceBufferGetHeight(surface);
		unsigned int width = CoreSurfaceBufferGetWidth(surface);
		unsigned int alignment = CGBitmapGetFastestAlignment();
		unsigned int alignmentedBytesPerRow = (width * 4 / alignment + 1) * alignment;
		if (!readblePixels) {
			readblePixels = CGBitmapAllocateData(alignmentedBytesPerRow * height);
		}
		unsigned int bytesPerRow = CoreSurfaceBufferGetBytesPerRow(surface);
		uint8_t* pixels = CoreSurfaceBufferGetBaseAddress(surface);
		CoreSurfaceBufferLock(surface, 3);
		for (unsigned int j = 0; j < height; j++) {
			memcpy(readblePixels + alignmentedBytesPerRow * j, pixels + bytesPerRow * j, bytesPerRow);
		}
		CoreSurfaceBufferUnlock(surface);
	}
	(*original_camera_callback)(cameraDevice,a,surface,b);
}


@implementation CameraTestAppDelegate

@synthesize window;
@synthesize cameraController;


- (IBAction)capturePhoto:(id)sender {
	[cameraController capturePhoto];
}


- (void)install_camera_callbackHook {
	char *p = NULL;
	object_getInstanceVariable(cameraController,"_camera",(void**)&p);
	if (!p) return;
	
	if (!original_camera_callback) {
		FUNC_camera_callback *funcP = (FUNC_camera_callback*)p;
		original_camera_callback = *(funcP+37);
		(funcP+37)[0] = __camera_callbackHook;
	}
}


- (IBAction)capturePreviewWithInstalledHook:(id)sender {
	char *p = NULL;
	object_getInstanceVariable(cameraController,"_camera",(void**)&p);
	if (!p) return;
	
	CoreSurfaceBufferRef surface = NULL;
	unsigned int width;
	unsigned int height;
	unsigned int bytesPerRow;
	surface = *(CoreSurfaceBufferRef*)(p+88);
	if (surface) {
		CoreSurfaceBufferLock(surface, 3);
		width = CoreSurfaceBufferGetWidth(surface);
		height = CoreSurfaceBufferGetHeight(surface);
		bytesPerRow = CoreSurfaceBufferGetBytesPerRow(surface);
		CoreSurfaceBufferUnlock(surface);
		
		if (readblePixels) {
			unsigned int alignment = CGBitmapGetFastestAlignment();
			unsigned int alignmentedBytesPerRow = (width * 4 / alignment + 1) * alignment;
			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, readblePixels,
																			 alignmentedBytesPerRow * height,
																			 NULL);
			CGImageRef imageRef = CGImageCreate(width,						// size_t width,
												height,						// size_t height,
												8,							// size_t bitsPerComponent,
												32,							// size_t bitsPerPixel,
												alignmentedBytesPerRow,		// size_t bytesPerRow,
												colorSpace,					// CGColorSpaceRef colorspace,
												(kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst),	// CGBitmapInfo bitmapInfo,
												dataProviderRef,			// CGDataProviderRef provider,
												NULL,						// const CGFloat decode[],
												YES,						// bool shouldInterpolate,
												kCGRenderingIntentDefault	// CGColorRenderingIntent intent
												);
			UIImage *image = [UIImage imageWithCGImage:imageRef];
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *pathToDefault = [documentsDirectory stringByAppendingPathComponent:@"HookPreview.png"];
			
			NSData *data = UIImagePNGRepresentation(image);
			[data writeToFile:pathToDefault atomically:NO];
			
			CGImageRelease(imageRef);
			CGDataProviderRelease(dataProviderRef);
			CGColorSpaceRelease(colorSpace);
		}
	}
}


- (IBAction)capturePreviewsFromCoreSurfaces:(id)sender {
	char *p = NULL;
	object_getInstanceVariable(cameraController,"_camera",(void**)&p);
	if (!p) return;
	
	for (int i = 0; i < 6; i++) {
		CoreSurfaceBufferRef surface = *(CoreSurfaceBufferRef*)(p+88+i*4);
		
		CoreSurfaceBufferLock(surface, 3);
		unsigned int height = CoreSurfaceBufferGetHeight(surface);
		unsigned int width = CoreSurfaceBufferGetWidth(surface);
		unsigned int bytesPerRow = CoreSurfaceBufferGetBytesPerRow(surface);
		void *pixels = CoreSurfaceBufferGetBaseAddress(surface);
		unsigned int alignment = CGBitmapGetFastestAlignment();
		unsigned int alignmentedBytesPerRow = (width * 4 / alignment + 1) * alignment;
		void *readblePixels = CGBitmapAllocateData(alignmentedBytesPerRow * height);
		for (unsigned int j = 0; j < height; j++) {
			memcpy(readblePixels + alignmentedBytesPerRow * j, pixels + bytesPerRow * j, bytesPerRow);
		}
		CoreSurfaceBufferUnlock(surface);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, readblePixels, alignmentedBytesPerRow * height, NULL);
		CGImageRef imageRef = CGImageCreate(width,						// size_t width,
											height,						// size_t height,
											8,							// size_t bitsPerComponent,
											32,							// size_t bitsPerPixel,
											alignmentedBytesPerRow,		// size_t bytesPerRow,
											colorSpace,					// CGColorSpaceRef colorspace,
											(kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst),	// CGBitmapInfo bitmapInfo,
											dataProviderRef,			// CGDataProviderRef provider,
											NULL,						// const CGFloat decode[],
											YES,						// bool shouldInterpolate,
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
		CGBitmapFreeData(readblePixels);
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
	NSLog(@"preview.size:%f,%f",preview.size.width,preview.size.height);
	
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
	self.cameraController = [objc_getClass("PLCameraController") sharedInstance];
	[cameraController setDelegate:self];
	UIView *previewView = [cameraController previewView];
	[cameraController startPreview];
	[self install_camera_callbackHook];
	[window addSubview:previewView];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
