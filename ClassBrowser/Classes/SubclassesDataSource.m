//
//  SubclassesDataSource.m
//  ClassBrowser
//

#import <objc/runtime.h>
#import "SubclassesDataSource.h"
#import "SubclassesCell.h"

@implementation SubclassesDataSource


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubclassesCell *cell = (SubclassesCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.subclassName.text = [[self objectForRowAtIndexPath:indexPath] description];
	Class class = objc_getClass([cell.subclassName.text cStringUsingEncoding:NSNEXTSTEPStringEncoding]);
	if (class) {
		cell.imagePath.text = [NSString stringWithCString:class_getImageName(class) encoding:NSNEXTSTEPStringEncoding];
	} else {
		cell.imagePath.text = nil;
	}
    return cell;
}


@end
