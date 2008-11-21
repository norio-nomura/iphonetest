//
//  IndexedDataSource.m
//  ClassBrowser
//

#import "IndexedDataSource.h"

@implementation NSObject(indexedDictionary)

- (NSString*)capitalChar {
	return [[[self description] substringToIndex:1] uppercaseString];
}

@end


@implementation NSDictionary(indexedDictionary)

- (id)initIndexedDictionaryWithArray:(NSArray*)array withSelector:(SEL)aSel {
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

@synthesize name;
@synthesize sectionIndexTitles;
@synthesize rows;


- (id)initWithArray:(NSArray*)array {
	return [self initWithArray:array withSelector:@selector(capitalChar)];
}


- (id)initWithArray:(NSArray*)array withSelector:(SEL)aSel {
	if (self = [super init]) {
		NSDictionary *dictionary = [[NSDictionary alloc] initIndexedDictionaryWithArray:array withSelector:aSel];
		self.rows = dictionary;
		[dictionary release];
		NSArray *sortedArray = [[NSArray alloc] initWithArray:[[self.rows allKeys] sortedArrayUsingSelector:@selector(compare:)]];
		self.sectionIndexTitles = sortedArray;
		[sortedArray release];
	}
	return self;
}


- (void)dealloc {
	[name release];
	[sectionIndexTitles release];
	[rows release];
    [super dealloc];
}


- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[rows objectForKey:[sectionIndexTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}


- (NSIndexPath*)indexPathForObject:(id)obj {
	NSString *initialChar = [[[obj description] substringToIndex:1] uppercaseString];
	NSUInteger section = [sectionIndexTitles indexOfObject:initialChar];
	NSUInteger row = [[rows objectForKey:initialChar] indexOfObject:[obj description]];
	if (section != NSNotFound && row != NSNotFound) {
		return [NSIndexPath indexPathForRow:row inSection:section];
	} else {
		return nil;
	}
}


#pragma mark UITableViewDataSource Protocol


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = [sectionIndexTitles count];
    return count ? count : 1;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [sectionIndexTitles count] > 1 ? sectionIndexTitles : nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.name];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:self.name] autorelease];
    }
	cell.text = [[self objectForRowAtIndexPath:indexPath] description];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [sectionIndexTitles count];
	if (count && [sectionIndexTitles objectAtIndex:section]) {
		return [[rows objectForKey:[sectionIndexTitles objectAtIndex:section]] count];
	} else {
		return 0;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([sectionIndexTitles count]) {
		return [sectionIndexTitles objectAtIndex:section];
	} else {
		return nil;
	}
}


@end
