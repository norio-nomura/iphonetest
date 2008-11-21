//
//  SubclassesDataSource.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "SubclassesDataSource.h"


@implementation SubclassesDataSource


@synthesize cellFromNib;


- (void)dealloc {
    [super dealloc];
}


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SubclassesCellIdentifier = @"SubclassesCell";
    SubclassesCell *cell = (SubclassesCell*)[tableView dequeueReusableCellWithIdentifier:SubclassesCellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SubclassesCell" owner:self options:nil];
		cell = cellFromNib;
    }
	cell.subclassName.text = [[self objectForRowAtIndexPath:indexPath] description];
	Class class = objc_getClass([cell.subclassName.text cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		cell.imagePath.text = [NSString stringWithCString:class_getImageName(class)];
	} else {
		cell.imagePath.text = nil;
	}
    return cell;
}


@end
