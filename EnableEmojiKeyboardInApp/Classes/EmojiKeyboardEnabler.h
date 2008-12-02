//
//  EmojiKeyboardEnabler.h
//

@interface EmojiKeyboardEnabler : NSObject {
	BOOL enable;
}

+ (id)shardInstance;

- (BOOL)available;
- (void)setEnable:(BOOL)yesOrNo;

@end
