//
//  IndexedDataSourceCell.m
//  ClassBrowser
//

#import "IndexedDataSourceCell.h"

@implementation IndexedDataSourceCell

@synthesize label;


- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
