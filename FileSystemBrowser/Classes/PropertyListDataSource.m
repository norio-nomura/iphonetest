//
//  PropertyListDataSource.m
//  FileSystemBrowser
//

#import "PropertyListDataSource.h"

@implementation PropertyListDataSource

@synthesize path;
@synthesize propertyList;
@synthesize rows;


- (void)dealloc {
	[path release];
	[propertyList release];
	[rows release];
	[super dealloc];
}


- (id)initWithPath:(NSString*)aPath {
	NSData *plistData = [NSData dataWithContentsOfFile:aPath];
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	plist = [NSPropertyListSerialization propertyListFromData:plistData
											 mutabilityOption:NSPropertyListImmutable
													   format:&format
											 errorDescription:&error];
	if(!plist){
		NSLog(error);
		[error release];
		[self autorelease];
		return nil;
	}
	self.propertyList = plist;
	
	return self;
}


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (cell) {
		cell.text = [[rows objectAtIndex:indexPath.row] description];
	}
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [rows count];
}


@end
