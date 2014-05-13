//
//  EmojiKeyboardEnabler.m
//

#import <objc/runtime.h>
#import "EmojiKeyboardEnabler.h"
#import "SharedInstanceMacro.h"

#define kEmojiInputMode @"emoji"

static EmojiKeyboardEnabler *shardInstance = nil;
static NSString *triggerInputMode = nil;
static BOOL emojiEnable = NO;
static BOOL addedEmojiToPreference = NO;

@implementation UIView(EmojiKeyboardEnabler)

- (id)__setInputMode:(NSString*)mode {
	id result;
	if (emojiEnable) {
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
	} else {
		result = [self __setInputMode:mode];
	}
	return result;
}

- (id)__inputModePreference {
	NSMutableArray *array;
	array = [NSMutableArray arrayWithArray:[self __inputModePreference]];
	if (emojiEnable) {
		if (NSNotFound == [array indexOfObject:kEmojiInputMode]) {
			if (!triggerInputMode) {
				triggerInputMode = [array lastObject];
			}
			[array addObject:kEmojiInputMode];
			addedEmojiToPreference = YES;
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
	} else {
		if (addedEmojiToPreference) {
			[array removeObject:kEmojiInputMode];
			addedEmojiToPreference = NO;
		}
	}

	return array;
}

@end

@implementation EmojiKeyboardEnabler

SHARD_INSTANCE_IMPL

- (BOOL)available {
	return [[[UIDevice currentDevice] systemVersion] isEqualToString:@"2.2"];
}

- (void)installHook {
	Class class = objc_getClass("UIKeyboardImpl");
	if (class) {
		method_exchangeImplementations(class_getInstanceMethod(class, @selector(setInputMode:)),
									   class_getInstanceMethod(class, @selector(__setInputMode:)));
		method_exchangeImplementations(class_getInstanceMethod(class, @selector(inputModePreference)),
									   class_getInstanceMethod(class, @selector(__inputModePreference)));
	}
}

- (id)init {
	if (self = [super init]) {
		if ([self available]) {
			[self installHook];
		}
	}
	return self;
}

- (void)setEnable:(BOOL)yesOrNo {
	emojiEnable = yesOrNo;

	// for reload inputModePreference
	BOOL v = [[NSUserDefaults standardUserDefaults] boolForKey:@"hoge"];
	[[NSUserDefaults standardUserDefaults] setBool:!v forKey:@"hoge"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
