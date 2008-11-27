//
//  EmojiKeyboardEnabler.m
//

#import <objc/runtime.h>
#import "EmojiKeyboardEnabler.h"

#define kEmojiInputMode @"emoji"

@implementation UIView(EmojiKeyboardEnabler)

static NSString *triggerInputMode = nil;


- (id)__setInputMode:(NSString*)mode {
	id result;
	if ([mode isEqual:triggerInputMode]) {
		static BOOL toggle = YES;
		if (toggle) {
			result = [self __setInputMode:kEmojiInputMode];
			toggle = NO;
		} else {
			result = [self __setInputMode:mode];
			toggle = YES;
		}
	} else {
		if ([mode isEqual:kEmojiInputMode]) {
			triggerInputMode = kEmojiInputMode;
		}
		result = [self __setInputMode:mode];
	}
	return result;
}


- (id)__inputModePreference {
	NSMutableArray *array;
	array = [self __inputModePreference];
	if (NSNotFound == [array indexOfObject:kEmojiInputMode]) {
		if (!triggerInputMode) {
			triggerInputMode = [array lastObject];
		}
		[array addObject:kEmojiInputMode];
	} else {
		if (!triggerInputMode) {
			for (NSUInteger i = [array count] - 1; i>=0; i--) {
				if (![[array objectAtIndex:i] isEqual:kEmojiInputMode]) {
					triggerInputMode = [array objectAtIndex:i];
					break;
				}
			}
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
