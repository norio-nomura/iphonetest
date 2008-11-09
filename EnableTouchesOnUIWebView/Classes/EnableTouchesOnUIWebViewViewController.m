//
//  EnableTouchesOnUIWebViewViewController.m
//  EnableTouchesOnUIWebView
//

#import "EnableTouchesOnUIWebViewViewController.h"
#import "TouchesHookForUIWebView.h"

@implementation EnableTouchesOnUIWebViewViewController

@synthesize touchesStartPoints;

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	touchesStartPoints = [[NSMutableDictionary alloc]initWithCapacity:5];
	installTouchesHookForUIWebView();
	
	UIWebView* myWebView = (UIWebView*)self.view;
	myWebView.scalesPageToFit = YES;
	myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ja.wikipedia.org/wiki/"]]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark UIWebView delegate methods


- (void)webViewDidStartLoad:(UIWebView *)webView {
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].isNetworkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].isNetworkActivityIndicatorVisible = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].isNetworkActivityIndicatorVisible = NO;
}


#pragma mark UIResponder methods


#define HORIZ_SWIPE_DRAG_MIN  10
#define VERT_SWIPE_DRAG_MAX   40


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesBegan");
	for (UITouch *touch in touches) {
		NSValue *point = [NSValue valueWithCGPoint:[touch locationInView:self.view]];
		NSValue *key = [NSValue valueWithPointer:touch];
		[touchesStartPoints setObject:point forKey:key];
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesMoved");
	if ([touches count] >= 3) {	// three fingers swipe check
		NSUInteger swipeCount = 0;
		CGPoint startPoint, currentPoint;
		for (UITouch *touch in touches) {
			NSValue *startValue = [touchesStartPoints objectForKey:[NSValue valueWithPointer:touch]];
			if (startValue) {
				startPoint = [startValue CGPointValue];
				currentPoint = [touch locationInView:self.view];
				if (fabsf(startPoint.x - currentPoint.x) >= HORIZ_SWIPE_DRAG_MIN &&
					fabsf(startPoint.y - currentPoint.y) <= VERT_SWIPE_DRAG_MAX) {
					swipeCount++;
					if (swipeCount >= 3) break;
				}
			}
		}
		if (swipeCount >= 3) {
			if (startPoint.x < currentPoint.x)
				[(UIWebView*)self.view goForward];
			else
				[(UIWebView*)self.view goBack];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesEnded");
	for (UITouch *touch in touches) {
		[touchesStartPoints removeObjectForKey:[NSValue valueWithPointer:touch]];
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesCancelled");
	for (UITouch *touch in touches) {
		[touchesStartPoints removeObjectForKey:[NSValue valueWithPointer:touch]];
	}
}


@end
