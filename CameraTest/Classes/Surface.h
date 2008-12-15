//
//  Surface.h
//

#import <Foundation/Foundation.h>

#ifndef CORESURFACE_H
typedef CFTypeRef CoreSurfaceBufferRef;
#endif

@interface Surface : NSObject {
	CoreSurfaceBufferRef coreSurfaceBuffer;
}

// you need call lock before access these properties.
@property (nonatomic,readonly) CoreSurfaceBufferRef coreSurfaceBuffer;
@property (nonatomic,readonly) unsigned int allocSize;
@property (nonatomic,readonly) unsigned int bytesPerRow;
@property (nonatomic,readonly) unsigned int height;
@property (nonatomic,readonly) unsigned int pixelFormatType;
@property (nonatomic,readonly) unsigned int id;
@property (nonatomic,readonly) unsigned int planeCount;
@property (nonatomic,readonly) unsigned int width;
@property (nonatomic,readonly) void *baseAddress;

+ (bool)dynamicLoad;

// initWithDictionaryKeys
+ (CFStringRef)kCoreSurfaceBufferGlobal;
+ (CFStringRef)kCoreSurfaceBufferMemoryRegion;
+ (CFStringRef)kCoreSurfaceBufferPitch;
+ (CFStringRef)kCoreSurfaceBufferWidth;
+ (CFStringRef)kCoreSurfaceBufferHeight;
+ (CFStringRef)kCoreSurfaceBufferPixelFormat;
+ (CFStringRef)kCoreSurfaceBufferAllocSize;
+ (CFStringRef)kCoreSurfaceBufferClientAddress;

// Class Method
+ (CoreSurfaceBufferRef)CoreSurfaceBufferCreate:(NSDictionary*)dictionary;
+ (unsigned int)CoreSurfaceBufferGetAllocSize:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetBytesPerRow:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetHeight:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetPixelFormatType:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetID:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetPlaneCount:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (unsigned int)CoreSurfaceBufferGetWidth:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (void *)CoreSurfaceBufferGetBaseAddress:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (int)CoreSurfaceBufferLock:(CoreSurfaceBufferRef)coreSurfaceBuffer;
+ (int)CoreSurfaceBufferUnlock:(CoreSurfaceBufferRef)coreSurfaceBuffer;

- (int)lock;
- (int)unlock;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)initWithCoreSurfaceBuffer:(CoreSurfaceBufferRef)surface;

@end
