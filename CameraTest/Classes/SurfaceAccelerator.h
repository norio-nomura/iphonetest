//
//  SurfaceAccelerator.h
//

#import <Foundation/Foundation.h>
#import "Surface.h"

#ifndef CORESURFACE_H
typedef CFTypeRef CoreSurfaceAcceleratorRef;
#endif

typedef CFTypeRef CameraDeviceRef;

typedef int (*FUNC_camera_callback)(CameraDeviceRef,int,CoreSurfaceBufferRef,int);

@interface SurfaceAccelerator : NSObject {
	CoreSurfaceAcceleratorRef coreSurfaceAccelerator;
	CameraDeviceRef cameraDevice;
}

@property (nonatomic,readonly) 	CoreSurfaceAcceleratorRef coreSurfaceAccelerator;

+ (bool)dynamicLoad;
+ (CFStringRef)kCoreSurfaceAcceleratorSymmetricTransformKey;

- (int)abortCaptures;
- (int)captureSurface:(CoreSurfaceBufferRef)dst width:(NSUInteger)width height:(NSUInteger)height withDictionary:(NSDictionary*)dict withCallback:(FUNC_camera_callback)func;
- (int)transferSurface:(CoreSurfaceBufferRef)src toSurface:(CoreSurfaceBufferRef)dst withDictionary:(NSDictionary*)dict;

- (id)initWithCoreSurfaceAccelerator:(CoreSurfaceAcceleratorRef)accelerator withCameraDevice:(CameraDeviceRef)camera;

@end
