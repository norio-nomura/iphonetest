//
//  CellFromNib.m
//

#import "CellFromNib.h"

@implementation CellFromNib

@synthesize label;


- (NSString*)text {
	return self.label.text;
}


- (void)setText:(NSString*)aText {
	self.label.text = aText;
}


- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
