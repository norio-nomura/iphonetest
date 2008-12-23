//
//  CameraTestAppDelegate.m
//  CameraTest
//

#import <objc/runtime.h>
#import "CameraTestAppDelegate.h"
#import "Surface.h"
#import "SurfaceAccelerator.h"

OBJC_EXPORT unsigned int CGBitmapGetFastestAlignment();
OBJC_EXPORT void * CGBitmapAllocateData(unsigned int);
OBJC_EXPORT void CGBitmapFreeData(const void *data);

static FUNC_camera_callback original_camera_callback = NULL;
static void *readblePixels = NULL;


static int __camera_callbackHook(CameraDeviceRef cameraDevice,int a,CoreSurfaceBufferRef coreSurfaceBuffer,int b) {
	CoreSurfaceAcceleratorRef coreSurfaceAccelerator = *(CoreSurfaceAcceleratorRef*)(cameraDevice+84);
	unsigned int surfaceId = [Surface CoreSurfaceBufferGetID:coreSurfaceBuffer];
	NSLog(@"cameraDevice:0x%x,a:0x%x,coreSurfaceBuffer:0x%x,ID:0x%x,b:0x%x,coreSurfaceAccelerator:0x%x",
		  cameraDevice,a,coreSurfaceBuffer,surfaceId,b,coreSurfaceAccelerator);
	if (coreSurfaceBuffer) {
		Surface *surface = [[Surface alloc]initWithCoreSurfaceBuffer:coreSurfaceBuffer];
		[surface lock];
		unsigned int height = surface.height;
		unsigned int width = surface.width;
		unsigned int alignment = CGBitmapGetFastestAlignment();
		unsigned int alignmentedBytesPerRow = (width * 4 / alignment + 1) * alignment;
		if (!readblePixels) {
			readblePixels = CGBitmapAllocateData(alignmentedBytesPerRow * height);
		}
		unsigned int bytesPerRow = surface.bytesPerRow;
		void *pixels = surface.baseAddress;
		for (unsigned int j = 0; j < height; j++) {
			memcpy(readblePixels + alignmentedBytesPerRow * j, pixels + bytesPerRow * j, bytesPerRow);
		}
		[surface unlock];
		[surface release];
	}
	return (*original_camera_callback)(cameraDevice,a,coreSurfaceBuffer,b);
}

#define K_CORESURFACE_COUNT	16
#define K_CORESURFACE_HEIGHT 1200
#define K_CORESURFACE_WIDTH 1600
#define K_CORESURFACE_PIXEL_FORMAT 'yuvs'
#define K_CORESURFACE_PIXEL_BYTES 2
#define K_CORESURFACE_MEMORY_REGION @"PurpleGfxMem"
/*
#define K_CORESURFACE_COUNT	16
#define K_CORESURFACE_HEIGHT 400
#define K_CORESURFACE_WIDTH 304
#define K_CORESURFACE_PIXEL_FORMAT 'BGRA'
#define K_CORESURFACE_PIXEL_BYTES 4
#define K_CORESURFACE_MEMORY_REGION @"PurpleGfxMem"
*/

static SurfaceAccelerator *surfaceAccelerator = nil;
static NSMutableArray *surfaceArray = nil;
static NSUInteger currentIndex = 0;

static int __camera_callbackHook2(CameraDeviceRef cameraDevice,int a,CoreSurfaceBufferRef coreSurfaceBuffer,int b) {
	CoreSurfaceAcceleratorRef coreSurfaceAccelerator = *(CoreSurfaceAcceleratorRef*)(cameraDevice+84);
	NSLog(@"cameraDevice:0x%x,a:0x%x,coreSurfaceBuffer:0x%x,b:0x%x,coreSurfaceAccelerator:0x%x",
		  cameraDevice,a,coreSurfaceBuffer,b,coreSurfaceAccelerator);
	if (!surfaceAccelerator) {
		surfaceAccelerator = [[SurfaceAccelerator alloc]initWithCoreSurfaceAccelerator:coreSurfaceAccelerator withCameraDevice:cameraDevice];
	}
	if (!surfaceArray) {
		surfaceArray = [[NSMutableArray alloc] initWithCapacity:K_CORESURFACE_COUNT];
	}
	Surface *nextSurface = nil;
	if ([surfaceArray count] < K_CORESURFACE_COUNT) {
		NSDictionary *surfaceCreateOptions = [NSDictionary dictionaryWithObjectsAndKeys:
											  [NSNumber numberWithInt:K_CORESURFACE_HEIGHT * K_CORESURFACE_WIDTH * K_CORESURFACE_PIXEL_BYTES],[Surface kCoreSurfaceBufferAllocSize],
											  [NSNumber numberWithInt:YES],[Surface kCoreSurfaceBufferGlobal],
											  [NSNumber numberWithInt:K_CORESURFACE_HEIGHT],[Surface kCoreSurfaceBufferHeight],
											  K_CORESURFACE_MEMORY_REGION,[Surface kCoreSurfaceBufferMemoryRegion],
											  [NSNumber numberWithInt:K_CORESURFACE_WIDTH * K_CORESURFACE_PIXEL_BYTES],[Surface kCoreSurfaceBufferPitch],
											  [NSNumber numberWithInt:K_CORESURFACE_PIXEL_FORMAT],[Surface kCoreSurfaceBufferPixelFormat],
											  [NSNumber numberWithInt:K_CORESURFACE_WIDTH],[Surface kCoreSurfaceBufferWidth],
											  nil];
		nextSurface = [[Surface alloc]initWithDictionary:surfaceCreateOptions];
		[surfaceArray addObject:nextSurface];
		[nextSurface release];
	} else {
		if (currentIndex < K_CORESURFACE_COUNT) {
			nextSurface = [surfaceArray objectAtIndex:currentIndex++];
		} else {
			nextSurface = [surfaceArray objectAtIndex:currentIndex=0];
		}
	}
	*(CoreSurfaceBufferRef*)(cameraDevice+136) = nextSurface.coreSurfaceBuffer;
	int result = 0;
//	NSDictionary *captureOptions = [NSDictionary dictionaryWithObjectsAndKeys:
//									[NSNumber numberWithInt:4],[SurfaceAccelerator kCoreSurfaceAcceleratorSymmetricTransformKey],
//									nil];
	NSMutableDictionary *captureOptions = [NSMutableDictionary dictionaryWithCapacity:0];
	result = [surfaceAccelerator captureSurface:nextSurface.coreSurfaceBuffer 
										  width:K_CORESURFACE_WIDTH 
										 height:K_CORESURFACE_HEIGHT 
								 withDictionary:captureOptions 
								   withCallback:0x33a8fda8];
	return result;
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
	
	CoreSurfaceBufferRef coreSurfaceBuffer = NULL;
	unsigned int width;
	unsigned int height;
	unsigned int bytesPerRow;
	coreSurfaceBuffer = *(CoreSurfaceBufferRef*)(p+88);
	if (coreSurfaceBuffer) {
		Surface *surface = [[Surface alloc]initWithCoreSurfaceBuffer:coreSurfaceBuffer];
		[surface lock];
		width = surface.width;
		height = surface.height;
		bytesPerRow = surface.bytesPerRow;
		[surface unlock];
		[surface release];
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
		CoreSurfaceBufferRef coreSurfaceBuffer = *(CoreSurfaceBufferRef*)(p+88+i*4);
		Surface *surface = [[Surface alloc]initWithCoreSurfaceBuffer:coreSurfaceBuffer];
		
		[surface lock];
		unsigned int height = surface.height;
		unsigned int width = surface.width;
		unsigned int bytesPerRow = surface.bytesPerRow;
		void *pixels = surface.baseAddress;
		unsigned int alignment = CGBitmapGetFastestAlignment();
		unsigned int alignmentedBytesPerRow = (width * 4 / alignment + 1) * alignment;
		void *readblePixels = CGBitmapAllocateData(alignmentedBytesPerRow * height);
		for (unsigned int j = 0; j < height; j++) {
			memcpy(readblePixels + alignmentedBytesPerRow * j, pixels + bytesPerRow * j, bytesPerRow);
		}
		[surface unlock];
		
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
	[Surface dynamicLoad];
	[self install_camera_callbackHook];
	[window addSubview:previewView];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
