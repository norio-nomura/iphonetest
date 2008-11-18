//
//  SubclassesCell.m
//  ClassBrowser
//
//  Created by 野村 憲男 on 08/11/18.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
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
