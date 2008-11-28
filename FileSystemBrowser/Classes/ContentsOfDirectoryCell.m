//
//  ContentsOfDirectoryCell.m
//  FileSystemBrowser
//

#import "ContentsOfDirectoryCell.h"

@implementation ContentsOfDirectoryCell

@synthesize mode;
@synthesize nlink;
@synthesize owner;
@synthesize group;
@synthesize name;


- (void)dealloc {
	[mode release];
	[nlink release];
	[owner release];
	[group release];
	[name release];
    [super dealloc];
}


- (void)setupFont {
	UIFont *courier;
	courier = [UIFont fontWithName:@"Courier" size:15];
	mode.font = courier;
	nlink.font = courier;
	owner.font = courier;
	group.font = courier;
	name.font = courier;
}


@end
