//
//  ContentsOfDirectoryDataSource.m
//  FileSystemBrowser
//

#import <string.h>
#import <sys/stat.h>
#import "ContentsOfDirectoryDataSource.h"
#import "ContentsOfDirectoryCell.h"

@implementation ContentsOfDirectoryDataSource

@synthesize path;


- (void)dealloc {
	[path release];
	[super dealloc];
}


- (id)initWithPath:(NSString*)aPath {
	NSError *error;
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aPath error:&error];
	if (!contents) {
		NSLog(@"%@",[error localizedDescription]);
	}
	if (self = [super initWithArray:contents usingSelector:@selector(firstChar)]) {
		self.nibIdentifier = NSStringFromClass([self class]);
		self.path = aPath;
		self.enableIndex = NO;
		self.enableSectionTitles = NO;
	}
	return self;
}


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ContentsOfDirectoryCell *cell = (ContentsOfDirectoryCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	[cell setupFont];

	NSString *content = [[self objectForRowAtIndexPath:indexPath] description];
	NSString *target = [path stringByAppendingPathComponent:content];
	NSDictionary *attributes = [[NSFileManager defaultManager] fileAttributesAtPath:target traverseLink:NO];
	
	char buf[20];
	struct stat s;
	lstat([target cStringUsingEncoding:NSNEXTSTEPStringEncoding],&s);
	strmode(s.st_mode,buf);
	cell.mode.text = [NSString stringWithCString:buf];
	cell.nlink.text = [NSString stringWithFormat:@"%u",[[attributes objectForKey:NSFileReferenceCount] unsignedLongValue]];
	cell.owner.text = [attributes objectForKey:NSFileOwnerAccountName];
	cell.group.text = [attributes objectForKey:NSFileGroupOwnerAccountName];
	if ([[attributes objectForKey:NSFileType] isEqual:NSFileTypeSymbolicLink]) {
		cell.name.text = [NSString stringWithFormat:@"%@ -> %@", content, [[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:target error:NULL]];
	} else {
		cell.name.text = content;
	}
	return cell;
}


@end
