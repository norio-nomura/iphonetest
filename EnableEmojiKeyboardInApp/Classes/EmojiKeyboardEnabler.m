//
//  EmojiKeyboardEnabler.m
//

#import <objc/runtime.h>
#import "EmojiKeyboardEnabler.h"

#define kEmojiInputMode @"emoji"

@implementation UIView(EmojiKeyboardEnabler)

static NSString *triggerInputMode = nil;


- (id)__setInputMode:(NSString*)mode {
	static BOOL toggle = NO;
	id result;
	if ([mode isEqual:kEmojiInputMode]) {
		result = [self __setInputMode:mode];
		toggle = NO;
	} else if (toggle && [mode isEqual:triggerInputMode]) {
		result = [self __setInputMode:kEmojiInputMode];
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
	if (NSNotFound == [array indexOfObject:kEmojiInputMode]) {
		[array addObject:kEmojiInputMode];
		if (!triggerInputMode) {
			triggerInputMode = [array objectAtIndex:0];
		}
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
