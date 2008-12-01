//
//  PropertyListNode.m
//  FileSystemBrowser
//

#import "PropertyListNode.h"

@implementation PropertyListNode

@synthesize level;
@synthesize state;
@synthesize key;
@synthesize value;


- (void)dealloc {
	[key release];
	[value release];
    [super dealloc];
}


- (id)initWithLevel:(NSInteger)aLevel withState:(PropertyListNodeStateOption)aState withKey:(NSString*)aKey withValue:(id)aValue {
	if (self = [super init]) {
		self.level = aLevel;
		self.state = aState;
		self.key = aKey;
		self.value = aValue;
	}
	return self;
}


@end
