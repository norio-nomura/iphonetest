//
//  PropertyListCell.m
//  FileSystemBrowser
//

#import "PropertyListCell.h"
#import "PropertyListNode.h"
#import "PropertyListViewController.h"

@implementation PropertyListCell

@synthesize indicator;
@synthesize key;
@synthesize value;
@synthesize viewController;


- (void)dealloc {
	[indicator release];
	[key release];
	[value release];
    [super dealloc];
}


- (void)setupFont {
	UIFont *courier;
	courier = [UIFont fontWithName:@"Courier" size:15];
	key.font = courier;
	value.font = courier;
}


- (void)setupFromNode:(PropertyListNode*)node {
	self.indentationLevel = node.level;
	self.indicator.enabled = node.state != NODE_IS_LEAF;
	self.indicator.selected = node.state == NODE_EXPANDED;
	self.key.text = node.key;
	if (node.state == NODE_IS_LEAF) {
		self.value.text = node.value;
		[indicator setImage:[UIImage imageNamed:@"btnDisabled.png"] forState:UIControlStateNormal];
		[indicator setImage:[UIImage imageNamed:@"btnDisabled.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
		[indicator setImage:[UIImage imageNamed:@"btnDisabled.png"] forState:UIControlStateDisabled];
		[indicator setImage:[UIImage imageNamed:@"btnDisabled.png"] forState:UIControlStateDisabled|UIControlStateHighlighted];
	} else {
		NSString *valueText = [[NSString alloc] initWithFormat:@"(%u items)",[node.value count]];
		self.value.text = valueText;
		[valueText release];
		[indicator setImage:[UIImage imageNamed:@"btnNormal.png"] forState:UIControlStateNormal];
		[indicator setImage:[UIImage imageNamed:@"btnNormal.png"] forState:UIControlStateNormal|UIControlStateHighlighted];
		[indicator setImage:[UIImage imageNamed:@"btnSelected.png"] forState:UIControlStateSelected];
		[indicator setImage:[UIImage imageNamed:@"btnSelected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
	}
}


- (IBAction)indicatorPushed:(id)sender {
	[viewController toggleOutline:self];
}


@end
