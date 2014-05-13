//
//  SurfaceAccelerator.m
//

#import <dlfcn.h>
#import "SurfaceAccelerator.h"

/* keys for the CoreSurfaceAcceleratorCapture dictionary. */
static CFStringRef *__kCoreSurfaceAcceleratorSymmetricTransformKey = NULL; /* CFNumberRef */

static int (*__CoreSurfaceAcceleratorAbortCaptures)(CoreSurfaceAcceleratorRef accel) = NULL;
static int (*__CoreSurfaceAcceleratorCaptureSurface)(CoreSurfaceAcceleratorRef accel,			// $r0
													 CoreSurfaceBufferRef destination,			// $r1
													 CFDictionaryRef dict,						// $r2
													 unsigned int unknown1,						// $r3
													 unsigned int height1,						// [sp]
													 unsigned int width1,						// [sp+4]
													 unsigned int unknown2,						// [sp+8]
													 unsigned int unknown3,						// [sp+12]
													 unsigned int height2,						// [sp+16]
													 unsigned int width2,						// [sp+20]
													 FUNC_camera_callback funcP,				// [sp+24]
													 CameraDeviceRef cameraDevice,				// [sp+28]
													 CoreSurfaceBufferRef sameAsAbove) = NULL;	// [sp+32]

static int (*__CoreSurfaceAcceleratorTransferSurface)(CoreSurfaceAcceleratorRef accel, CoreSurfaceBufferRef src, CoreSurfaceBufferRef dst, CFDictionaryRef dict) = NULL;

@implementation SurfaceAccelerator

@synthesize coreSurfaceAccelerator;


+ (bool)dynamicLoad {
	static bool isDynamicLoaded = NO;
	if (!isDynamicLoaded) {
		void *dl = dlopen("/System/Library/PrivateFrameworks/CoreSurface.framework/CoreSurface",RTLD_LAZY);
		if (dl) {
			__kCoreSurfaceAcceleratorSymmetricTransformKey = dlsym(dl,"kCoreSurfaceAcceleratorSymmetricTransformKey");

			__CoreSurfaceAcceleratorAbortCaptures = dlsym(dl,"CoreSurfaceAcceleratorAbortCaptures");
			__CoreSurfaceAcceleratorCaptureSurface = dlsym(dl,"CoreSurfaceAcceleratorCaptureSurface");
			__CoreSurfaceAcceleratorTransferSurface = dlsym(dl,"CoreSurfaceAcceleratorTransferSurface");

			dlclose(dl);
			isDynamicLoaded = YES;
		}
	}
	return isDynamicLoaded;
}


#pragma mark dictionary key


+ (CFStringRef)kCoreSurfaceAcceleratorSymmetricTransformKey {
	return *__kCoreSurfaceAcceleratorSymmetricTransformKey;
}


#pragma mark Instance Methods


- (int)abortCaptures {
	return __CoreSurfaceAcceleratorAbortCaptures(coreSurfaceAccelerator);
}


//- (int)captureSurface:(CoreSurfaceBufferRef)dst withDictionary:(NSDictionary*)dict withCallback:(FUNC_camera_callback)func {
- (int)captureSurface:(CoreSurfaceBufferRef)dst width:(NSUInteger)width height:(NSUInteger)height withDictionary:(NSDictionary*)dict withCallback:(FUNC_camera_callback)func {
//	[Surface CoreSurfaceBufferLock:dst];
//	int height = [Surface CoreSurfaceBufferGetHeight:dst];
//	int width = [Surface CoreSurfaceBufferGetWidth:dst];
//	[Surface CoreSurfaceBufferUnlock:dst];
	int result = __CoreSurfaceAcceleratorCaptureSurface(coreSurfaceAccelerator,
														dst,
														(CFDictionaryRef)dict,
														1,
														height,width,
														0,
														0,
														height,width,
														func,
														cameraDevice,
														dst);
	return result;
}


- (int)transferSurface:(CoreSurfaceBufferRef)src toSurface:(CoreSurfaceBufferRef)dst withDictionary:(NSDictionary*)dict{
	int result = __CoreSurfaceAcceleratorTransferSurface(coreSurfaceAccelerator, src, dst, (CFDictionaryRef)dict);
	return result;
}


#pragma mark initializer


- (id)initWithCoreSurfaceAccelerator:(CoreSurfaceAcceleratorRef)accelerator withCameraDevice:(CameraDeviceRef)camera{
	if (![[self class] dynamicLoad]) {
		[self autorelease];
		return nil;
	}
	if (self = [super init]) {
		coreSurfaceAccelerator = CFRetain(accelerator);
		cameraDevice = CFRetain(camera);
	}
	return self;
}


- (void)dealloc {
	if (coreSurfaceAccelerator) {
		CFRelease(coreSurfaceAccelerator);
	}
	if (cameraDevice) {
		CFRelease(cameraDevice);
	}
    [super dealloc];
}


@end
