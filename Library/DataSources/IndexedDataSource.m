//
//  IndexedDataSource.m
//

#import "IndexedDataSource.h"

@implementation NSObject(indexedDictionary)


- (NSString*)capitalChar {
	return [[[self description] substringToIndex:1] uppercaseString];
}


- (NSString*)firstChar {
	return [[self description] substringToIndex:1];
}


@end

@implementation NSDictionary(indexedDictionary)


- (id)initIndexedDictionaryWithArray:(NSArray*)array usingSelector:(SEL)aSel {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	for (id obj in array) {
		NSString *indexString = [obj performSelector:aSel];
		if (indexString) {
			NSMutableArray *array = [dictionary objectForKey:indexString];
			if (array) {
				[array addObject:obj];
			} else {
				array = [[NSMutableArray alloc] initWithObjects:obj,nil];
				[dictionary setObject:array forKey:indexString];
				[array release];
			}
		}
	}
	for (id key in [dictionary allKeys]) {
		NSArray *sortedArray = [[NSArray alloc] initWithArray:[[dictionary objectForKey:key] sortedArrayUsingSelector:@selector(compare:)]];
		[dictionary setObject:sortedArray forKey:key];
		[sortedArray release];
	}
	self = [self initWithDictionary:dictionary];
	[dictionary release];
	return self;
}


@end

@implementation IndexedDataSource

@synthesize sectionTitles;
@synthesize rows;
@synthesize enableIndex;
@synthesize enableSectionTitles;


- (id)initWithArray:(NSArray*)array {
	return [self initWithArray:array usingSelector:@selector(capitalChar)];
}


- (id)initWithArray:(NSArray*)array usingSelector:(SEL)aSel {
	if (self = [super init]) {
		selectorForIndex = aSel;
		NSDictionary *dictionary = [[NSDictionary alloc] initIndexedDictionaryWithArray:array usingSelector:selectorForIndex];
		self.rows = dictionary;
		[dictionary release];
		NSArray *sortedArray = [[NSArray alloc] initWithArray:[[rows allKeys] sortedArrayUsingSelector:@selector(compare:)]];
		self.sectionTitles = sortedArray;
		[sortedArray release];
		
		self.enableIndex = YES;
		self.enableSectionTitles = YES;
	}
	return self;
}


- (void)dealloc {
	[sectionTitles release];
	[rows release];
    [super dealloc];
}


- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[rows objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}


- (NSIndexPath*)indexPathForObject:(id)obj {
	NSString *indexString = [obj performSelector:selectorForIndex];
	NSUInteger section = [sectionTitles indexOfObject:indexString];
	NSUInteger row = [[rows objectForKey:indexString] indexOfObject:[obj description]];
	if (section != NSNotFound && row != NSNotFound) {
		return [NSIndexPath indexPathForRow:row inSection:section];
	} else {
		return nil;
	}
}


#pragma mark UITableViewDataSource Protocol


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = [sectionTitles count];
    return count ? count : 1;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return ([sectionTitles count] > 1 && enableIndex) ? sectionTitles : nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (cell) {
		cell.text = [[self objectForRowAtIndexPath:indexPath] description];
	}
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [sectionTitles count];
	if (count && [sectionTitles objectAtIndex:section]) {
		return [[rows objectForKey:[sectionTitles objectAtIndex:section]] count];
	} else {
		return 0;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (enableSectionTitles && [sectionTitles count]) {
		return [sectionTitles objectAtIndex:section];
	} else {
		return nil;
	}
}


@end
