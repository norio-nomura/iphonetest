//
//  EmojiKeyboardEnabler.m
//

#import <objc/runtime.h>
#import "EmojiKeyboardEnabler.h"

@implementation NSObject(EmojiHack)


- (id)__setInputMode:(NSString*)obj {
	static BOOL toggle = YES;
	NSLog(@"%@",obj);
	id result;
	if (toggle && [obj isEqual:@"ja_JP-Romaji"]) {
		result = [self __setInputMode:@"emoji"];
		toggle = NO;
	} else {
		result = [self __setInputMode:obj];
		toggle = YES;
	}
	return result;
}


@end


static BOOL installedEmojiKeyboardEnabler = NO;


BOOL installEmojiKeyboardEnabler() {
	if (!installedEmojiKeyboardEnabler) {
		Class class = objc_getClass("UIKeyboardImpl");
		if (class) {
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(setInputMode:)),
										   class_getInstanceMethod(class, @selector(__setInputMode:)));
			installedEmojiKeyboardEnabler = YES;
			return YES;
		}
	}
	return NO;
}


BOOL uninstallEmojiKeyboardEnabler() {
	if (installedEmojiKeyboardEnabler) {
		Class class = objc_getClass("UIKeyboardImpl");
		if (class) {
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(setInputMode:)),
										   class_getInstanceMethod(class, @selector(__setInputMode:)));
			installedEmojiKeyboardEnabler = NO;
			return YES;
		}
	}
	return NO;
}
