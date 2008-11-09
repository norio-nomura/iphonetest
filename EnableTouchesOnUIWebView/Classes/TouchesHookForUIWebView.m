//
//  TouchesHookForUIWebView.m
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "TouchesHookForUIWebView.h"

@implementation UIView(__TouchesHookForUIWebView)

- (void)__touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self __touchesBegan:touches withEvent:event];
	UIView* webView = self.superview;
	while (webView && ![[webView class] isSubclassOfClass:[UIWebView class]]) {
		webView = webView.superview;
	}
	if (webView) {
		[webView touchesBegan:touches withEvent:event];
	}
}

- (void)__touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self __touchesMoved:touches withEvent:event];
	UIView* webView = self.superview;
	while (webView && ![[webView class] isSubclassOfClass:[UIWebView class]]) {
		webView = webView.superview;
	}
	if (webView) {
		[webView touchesMoved:touches withEvent:event];
	}
}

- (void)__touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self __touchesEnded:touches withEvent:event];
	UIView* webView = self.superview;
	while (webView && ![[webView class] isSubclassOfClass:[UIWebView class]]) {
		webView = webView.superview;
	}
	if (webView) {
		[webView touchesEnded:touches withEvent:event];
	}
}

- (void)__touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self __touchesCancelled:touches withEvent:event];
	UIView* webView = self.superview;
	while (webView && ![[webView class] isSubclassOfClass:[UIWebView class]]) {
		webView = webView.superview;
	}
	if (webView) {
		[webView touchesCancelled:touches withEvent:event];
	}
}

@end

static BOOL installedTouchesHookForUIWebView = NO;

BOOL installTouchesHookForUIWebView() {
	if (!installedTouchesHookForUIWebView) {
		Class class = objc_getClass("UIWebDocumentView");
		if (class) {
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesBegan:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesBegan:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesMoved:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesMoved:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesEnded:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesEnded:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesCancelled:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesCancelled:withEvent:)));
			installedTouchesHookForUIWebView = YES;
			return YES;
		}
	}
	return NO;
}

BOOL uninstallTouchesHookForUIWebView() {
	if (installedTouchesHookForUIWebView) {
		Class class = objc_getClass("UIWebDocumentView");
		if (class) {
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesBegan:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesBegan:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesMoved:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesMoved:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesEnded:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesEnded:withEvent:)));
			method_exchangeImplementations(class_getInstanceMethod(class, @selector(touchesCancelled:withEvent:)),
										   class_getInstanceMethod(class, @selector(__touchesCancelled:withEvent:)));
			installedTouchesHookForUIWebView = NO;
			return YES;
		}
	}
	return NO;
}
