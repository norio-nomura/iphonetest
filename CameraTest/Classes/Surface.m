//
//  Surface.m
//

#import <dlfcn.h>
#import "Surface.h"

/* Keys for the CoreSurfaceBufferCreate dictionary. */
static CFStringRef *__kCoreSurfaceBufferGlobal = NULL;        /* CFBoolean */
static CFStringRef *__kCoreSurfaceBufferMemoryRegion = NULL;  /* CFStringRef */
static CFStringRef *__kCoreSurfaceBufferPitch = NULL;         /* CFNumberRef */
static CFStringRef *__kCoreSurfaceBufferWidth = NULL;         /* CFNumberRef */
static CFStringRef *__kCoreSurfaceBufferHeight = NULL;        /* CFNumberRef */
static CFStringRef *__kCoreSurfaceBufferPixelFormat = NULL;   /* CFNumberRef (fourCC) */
static CFStringRef *__kCoreSurfaceBufferAllocSize = NULL;     /* CFNumberRef */
static CFStringRef *__kCoreSurfaceBufferClientAddress = NULL; /* CFNumberRef */

static CoreSurfaceBufferRef (*__CoreSurfaceBufferCreate)(CFDictionaryRef dict) = NULL;
static unsigned int (*__CoreSurfaceBufferGetAllocSize)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetBytesPerRow)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetHeight)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetPixelFormatType)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetID)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetPlaneCount)(CoreSurfaceBufferRef surface) = NULL;
static unsigned int (*__CoreSurfaceBufferGetWidth)(CoreSurfaceBufferRef surface) = NULL;

/* lockType is one of kCoreSurfaceLockType*. */
static int (*__CoreSurfaceBufferLock)(CoreSurfaceBufferRef surface, unsigned int lockType) = NULL;
static int (*__CoreSurfaceBufferUnlock)(CoreSurfaceBufferRef surface) = NULL;
static void *(*__CoreSurfaceBufferGetBaseAddress)(CoreSurfaceBufferRef surface) = NULL;

@implementation Surface

@synthesize coreSurfaceBuffer;


+ (bool)dynamicLoad {
	static bool isDynamicLoaded = NO;
	if (!isDynamicLoaded) {
		void *dl = dlopen("/System/Library/PrivateFrameworks/CoreSurface.framework/CoreSurface",RTLD_LAZY);
		if (dl) {
			__kCoreSurfaceBufferGlobal = dlsym(dl, "kCoreSurfaceBufferGlobal");
			__kCoreSurfaceBufferMemoryRegion = dlsym(dl, "kCoreSurfaceBufferMemoryRegion");
			__kCoreSurfaceBufferPitch = dlsym(dl, "kCoreSurfaceBufferPitch");
			__kCoreSurfaceBufferWidth = dlsym(dl, "kCoreSurfaceBufferWidth");
			__kCoreSurfaceBufferHeight = dlsym(dl, "kCoreSurfaceBufferHeight");
			__kCoreSurfaceBufferPixelFormat = dlsym(dl, "kCoreSurfaceBufferPixelFormat");
			__kCoreSurfaceBufferAllocSize = dlsym(dl, "kCoreSurfaceBufferAllocSize");
			__kCoreSurfaceBufferClientAddress = dlsym(dl, "kCoreSurfaceBufferClientAddress");
			
			__CoreSurfaceBufferCreate = dlsym(dl, "CoreSurfaceBufferCreate");
			__CoreSurfaceBufferGetAllocSize = dlsym(dl, "CoreSurfaceBufferGetAllocSize");
			__CoreSurfaceBufferGetBytesPerRow = dlsym(dl, "CoreSurfaceBufferGetBytesPerRow");
			__CoreSurfaceBufferGetHeight = dlsym(dl, "CoreSurfaceBufferGetHeight");
			__CoreSurfaceBufferGetPixelFormatType = dlsym(dl, "CoreSurfaceBufferGetPixelFormatType");
			__CoreSurfaceBufferGetID = dlsym(dl, "CoreSurfaceBufferGetID");
			__CoreSurfaceBufferGetPlaneCount = dlsym(dl, "CoreSurfaceBufferGetPlaneCount");
			__CoreSurfaceBufferGetWidth = dlsym(dl, "CoreSurfaceBufferGetWidth");
			
			__CoreSurfaceBufferLock = dlsym(dl,"CoreSurfaceBufferLock");
			__CoreSurfaceBufferUnlock = dlsym(dl,"CoreSurfaceBufferUnlock");
			__CoreSurfaceBufferGetBaseAddress = dlsym(dl,"CoreSurfaceBufferGetBaseAddress");

			dlclose(dl);
			isDynamicLoaded = YES;
		}
	}
	return isDynamicLoaded;
}


#pragma mark initWithDictionaryKeys


+ (CFStringRef)kCoreSurfaceBufferGlobal {
	return *__kCoreSurfaceBufferGlobal;
}


+ (CFStringRef)kCoreSurfaceBufferMemoryRegion {
	return *__kCoreSurfaceBufferMemoryRegion;
}


+ (CFStringRef)kCoreSurfaceBufferPitch {
	return *__kCoreSurfaceBufferPitch;
}


+ (CFStringRef)kCoreSurfaceBufferWidth {
	return *__kCoreSurfaceBufferWidth;
}


+ (CFStringRef)kCoreSurfaceBufferHeight {
	return *__kCoreSurfaceBufferHeight;
}


+ (CFStringRef)kCoreSurfaceBufferPixelFormat {
	return *__kCoreSurfaceBufferPixelFormat;
}


+ (CFStringRef)kCoreSurfaceBufferAllocSize {
	return *__kCoreSurfaceBufferAllocSize;
}


+ (CFStringRef)kCoreSurfaceBufferClientAddress {
	return *__kCoreSurfaceBufferClientAddress;
}


#pragma mark Class Method


+ (CoreSurfaceBufferRef)CoreSurfaceBufferCreate:(NSDictionary*)dictionary {
	return __CoreSurfaceBufferCreate((CFDictionaryRef)dictionary);
}


+ (unsigned int)CoreSurfaceBufferGetAllocSize:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetAllocSize(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetBytesPerRow:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetBytesPerRow(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetHeight:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetHeight(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetPixelFormatType:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetPixelFormatType(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetID:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetID(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetPlaneCount:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetPlaneCount(coreSurfaceBuffer);
}


+ (unsigned int)CoreSurfaceBufferGetWidth:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetWidth(coreSurfaceBuffer);
}


+ (void *)CoreSurfaceBufferGetBaseAddress:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferGetBaseAddress(coreSurfaceBuffer);
}


+ (int)CoreSurfaceBufferLock:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	/* lockType is one of kCoreSurfaceLockType*. */
	return __CoreSurfaceBufferLock(coreSurfaceBuffer,3);
}


+ (int)CoreSurfaceBufferUnlock:(CoreSurfaceBufferRef)coreSurfaceBuffer {
	return __CoreSurfaceBufferUnlock(coreSurfaceBuffer);
}


#pragma mark properties


- (unsigned int)allocSize {
	return [[self class]CoreSurfaceBufferGetAllocSize:coreSurfaceBuffer];
}


- (unsigned int)bytesPerRow {
	return [[self class]CoreSurfaceBufferGetBytesPerRow:coreSurfaceBuffer];
}


- (unsigned int)height {
	return [[self class]CoreSurfaceBufferGetHeight:coreSurfaceBuffer];
}


- (unsigned int)pixelFormatType {
	return [[self class]CoreSurfaceBufferGetPixelFormatType:coreSurfaceBuffer];
}


- (unsigned int)id {
	return [[self class]CoreSurfaceBufferGetID:coreSurfaceBuffer];
}


- (unsigned int)planeCount {
	return [[self class]CoreSurfaceBufferGetPlaneCount:coreSurfaceBuffer];
}


- (unsigned int)width {
	return [[self class]CoreSurfaceBufferGetWidth:coreSurfaceBuffer];
}


- (void *)baseAddress {
	return [[self class]CoreSurfaceBufferGetBaseAddress:coreSurfaceBuffer];
}


#pragma mark Instance Methods


- (int)lock {
	/* lockType is one of kCoreSurfaceLockType*. */
	return [[self class]CoreSurfaceBufferLock:coreSurfaceBuffer];
}


- (int)unlock {
	return [[self class]CoreSurfaceBufferUnlock:coreSurfaceBuffer];
}


#pragma mark initializer


- (id)initWithDictionary:(NSDictionary*)dictionary {
	if (![[self class] dynamicLoad]) {
		[self autorelease];
		return nil;
	}
	if (self = [super init]) {
		coreSurfaceBuffer = [[self class]CoreSurfaceBufferCreate:dictionary];
	}
	return self;
}


- (id)initWithCoreSurfaceBuffer:(CoreSurfaceBufferRef)surface {
	if (![[self class] dynamicLoad]) {
		[self autorelease];
		return nil;
	}
	if (self = [super init]) {
		coreSurfaceBuffer = CFRetain(surface);
	}
	return self;
}


- (void)dealloc {
	if (coreSurfaceBuffer) {
		CFRelease(coreSurfaceBuffer);
	}
    [super dealloc];
}


@end
