//
//  EmojiKeyboardEnabler.m
//

#import <objc/runtime.h>
#import "EmojiKeyboardEnabler.h"

@implementation UIView(EmojiKeyboardEnabler)

static NSString *triggerInputMode = nil;


- (id)__setInputMode:(NSString*)mode {
	static BOOL toggle = YES;
	id result;
	if (toggle && [mode isEqual:triggerInputMode]) {
		result = [self __setInputMode:@"emoji"];
		toggle = NO;
	} else {
		result = [self __setInputMode:mode];
		toggle = YES;
	}
	return result;
}


- (id)__inputModePreference {
	NSMutableArray *array;
	array = [self __inputModePreference];
	if (!triggerInputMode) {
		triggerInputMode = [array objectAtIndex:0];
	}
	if (NSNotFound == [array indexOfObject:@"emoji"]) {
		[array addObject:@"emoji"];
	}
	return array;
}


@end

static BOOL installedEmojiKeyboardEnabler = NO;


BOOL EmojiKeyboardEnable(BOOL bEnable) {
	if (installedEmojiKeyboardEnabler != bEnable) {
		Class class = objc_getClass("UIKeyboardImpl");
		if (class) {
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(setInputMode:)),
										   class_getInstanceMethod(class, @selector(__setInputMode:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(inputModePreference)),
										   class_getInstanceMethod(class, @selector(__inputModePreference)));
			installedEmojiKeyboardEnabler = bEnable;
			return YES;
		}
	}
	return NO;
}


BOOL installEmojiKeyboardEnabler() {
	return EmojiKeyboardEnable(YES);
}


BOOL uninstallEmojiKeyboardEnabler() {
	return EmojiKeyboardEnable(NO);
}
