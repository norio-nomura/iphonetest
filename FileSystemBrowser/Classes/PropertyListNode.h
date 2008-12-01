//
//  PropertyListNode
//  FileSystemBrowser
//

#import <Foundation/Foundation.h>

enum PropertyListNodeState {
	NODE_IS_LEAF,
	NODE_COLLAPSED,
	NODE_EXPANDED
};
typedef NSUInteger PropertyListNodeStateOption;

@interface PropertyListNode : NSObject {
	NSInteger level;
	PropertyListNodeStateOption state;
	NSString *key;
	id value;
}

@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) PropertyListNodeStateOption state;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) id value;

- (id)initWithLevel:(NSInteger)aLevel withState:(PropertyListNodeStateOption)aState withKey:(NSString*)aKey withValue:(id)aValue;

@end
