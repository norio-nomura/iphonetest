//
//  ClassDataSource.m
//  ClassBrowser
//

#import "ClassDataSource.h"

@interface NSArray(indexedDictionary)
- (NSDictionary*)indexedDictionary;
@end


@implementation NSArray(indexedDictionary)

- (NSDictionary*)indexedDictionary {
	NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
	for (id obj in self) {
		NSString *initialChar = [[[obj description] substringToIndex:1] uppercaseString];
		NSMutableArray *array = [dictionary objectForKey:initialChar];
		if (array) {
			[array addObject:obj];
		} else {
			array = [[NSMutableArray alloc] initWithObjects:obj,nil];
			[dictionary setObject:array forKey:initialChar];
			[array release];
		}
	}
	for (id key in [dictionary allKeys]) {
		NSArray *array = [dictionary objectForKey:key];
		[dictionary setObject:[array sortedArrayUsingSelector:@selector(compare:)] forKey:key];
	}
	return dictionary;
}

@end


@implementation ClassDataSource

@synthesize name;
@synthesize sectionIndexTitles;
@synthesize rows;


- (id)initWithArray:(NSArray*)array {
	return [self initWithDictionary:[array indexedDictionary]];
}


- (id)initWithDictionary:(NSDictionary*)dictionary {
	if (self = [super init]) {
		self.rows = dictionary;
		self.sectionIndexTitles = [[self.rows allKeys] sortedArrayUsingSelector:@selector(compare:)];
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
	cell.text = [self objectForRowAtIndexPath:indexPath];
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
