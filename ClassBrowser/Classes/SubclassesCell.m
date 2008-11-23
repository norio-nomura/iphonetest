//
//  SubclassesCell.m
//  ClassBrowser
//

#import "SubclassesCell.h"

@implementation SubclassesCell

@synthesize subclassName;
@synthesize imagePath;


- (void)dealloc {
	[subclassName release];
	[imagePath release];
    [super dealloc];
}


@end
