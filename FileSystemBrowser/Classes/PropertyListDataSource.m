//
//  PropertyListDataSource.m
//  FileSystemBrowser
//

#import "PropertyListDataSource.h"
#import "PropertyListCell.h"
#import "PropertyListNode.h"

#define K_INDEX_LEVEL 0
#define K_INDEX_EXPANDED 1
#define K_INDEX_KEY	2
#define K_INDEX_VALUE 3

@interface PropertyListDataSource(__private)
- (NSArray*)newNodeArrayWithArray:(NSArray*)array asLevel:(NSInteger)level;
- (NSArray*)newNodeArrayWithDictionary:(NSDictionary*)dictionary asLevel:(NSInteger)level;
- (PropertyListNode*)nodeFromArray:(NSArray*)array withLevel:(NSInteger)level andIndexPath:(NSIndexPath*)indexPath;
- (PropertyListNode*)nodeFromIndexPath:(NSIndexPath*)indexPath;
@end


@implementation PropertyListDataSource

@synthesize path;
@synthesize propertyList;
@synthesize nodes;
@synthesize rowToIndexPath;
@synthesize viewController;


- (void)dealloc {
	[path release];
	[propertyList release];
	[nodes release];
	[rowToIndexPath release];
	[super dealloc];
}


- (id)initWithPath:(NSString*)aPath {
	if (self = [super initWithNibIdentifier:NSStringFromClass([PropertyListDataSource class])]) {
		NSData *plistData = [NSData dataWithContentsOfFile:aPath];
		NSString *error;
		NSPropertyListFormat format;
		id plist = [NSPropertyListSerialization propertyListFromData:plistData
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
		if ([propertyList isKindOfClass:[NSDictionary class]]) {
			NSArray *array = [self newNodeArrayWithDictionary:propertyList asLevel:0];
			self.nodes = array;
			[array release];
		} else if ([propertyList isKindOfClass:[NSArray class]]) {
			NSArray *array = [self newNodeArrayWithArray:propertyList asLevel:0];
			self.nodes = array;
			[array release];
		} else {
		}
		NSMutableArray *indexPathes = [[NSMutableArray alloc] initWithCapacity:[nodes count]];
		for (NSUInteger i = 0; i < [nodes count]; i++) {
			[indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}
		self.rowToIndexPath = indexPathes;
		[indexPathes release];
	}
	return self;
}


- (NSArray*)newNodeArrayWithDictionary:(NSDictionary*)dictionary asLevel:(NSInteger)level {
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
	for (NSString *key in [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
		id obj = [dictionary objectForKey:key];
		PropertyListNodeStateOption state;
		id value;
		if ([obj isKindOfClass:[NSDictionary class]]) {
			state = NODE_COLLAPSED;
			value = [self newNodeArrayWithDictionary:obj asLevel:level + 1];
		} else if ([obj isKindOfClass:[NSArray class]]) {
			state = NODE_COLLAPSED;
			value = [self newNodeArrayWithArray:obj asLevel:level + 1];
		} else {
			state = NODE_IS_LEAF;
			value = [[NSString alloc] initWithFormat:@"%@",obj];
		}
		PropertyListNode *node = [[PropertyListNode alloc] initWithLevel:level withState:state withKey:key withValue:value];
		[result addObject:node];
		[node release];
		[value release];
	}
	return result;
}


- (NSArray*)newNodeArrayWithArray:(NSArray*)array asLevel:(NSInteger)level {
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[array count]];
	for (NSUInteger i = 0; i < [array count]; i++) {
		id obj = [array objectAtIndex:i];
		PropertyListNodeStateOption state;
		NSString *key = [[NSString alloc] initWithFormat:@"item %u",i];
		id value;
		if ([obj isKindOfClass:[NSDictionary class]]) {
			state = NODE_COLLAPSED;
			value = [self newNodeArrayWithDictionary:obj asLevel:level + 1];
		} else if ([obj isKindOfClass:[NSArray class]]) {
			state = NODE_COLLAPSED;
			value = [self newNodeArrayWithArray:obj asLevel:level + 1];
		} else {
			state = NODE_IS_LEAF;
			value = [[NSString alloc] initWithFormat:@"%@",obj];
		}
		PropertyListNode *node = [[PropertyListNode alloc] initWithLevel:level withState:state withKey:key withValue:value];
		[result addObject:node];
		[node release];
		[value release];
		[key release];
	}
	return result;
}


- (PropertyListNode*)nodeFromArray:(NSArray*)array withLevel:(NSInteger)level andIndexPath:(NSIndexPath*)indexPath {
	PropertyListNode *node = [array objectAtIndex:[indexPath indexAtPosition:level]];
	if (node.state == NODE_IS_LEAF || level == [indexPath length]-1) {
		return node;
	} else {
		return [self nodeFromArray:node.value withLevel:level+1 andIndexPath:indexPath];
	}
}


- (PropertyListNode*)nodeFromIndexPath:(NSIndexPath*)indexPath {
	return [self nodeFromArray:nodes withLevel:1 andIndexPath:indexPath];
}


- (NSIndexPath*)indexPathFromUITableIndexPath:(NSIndexPath*)uiIndexPath {
	return [rowToIndexPath objectAtIndex:uiIndexPath.row];
}


#pragma mark Public method


- (NSArray*)newExpandChild:(NSIndexPath*)uiIndexPath {
	NSIndexPath *indexPath = [self indexPathFromUITableIndexPath:uiIndexPath];
	PropertyListNode *parentNode = [self nodeFromIndexPath:indexPath];
	if (parentNode.state != NODE_COLLAPSED) {
		return nil;
	} else {
		NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[parentNode.value count]];
		for (NSUInteger i = 0; i < [parentNode.value count]; i++) {
			[rowToIndexPath insertObject:[indexPath indexPathByAddingIndex:i] atIndex:uiIndexPath.row + i + 1];
			[result addObject:[NSIndexPath indexPathForRow:uiIndexPath.row + i + 1 inSection:0]];
		}
		parentNode.state = NODE_EXPANDED;
		return result;
	}
}


- (NSArray*)newCollapseChild:(NSIndexPath*)uiIndexPath {
	NSIndexPath *indexPath = [self indexPathFromUITableIndexPath:uiIndexPath];
	PropertyListNode *parentNode = [self nodeFromIndexPath:indexPath];
	if (parentNode.state != NODE_EXPANDED) {
		return nil;
	} else {
		NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[parentNode.value count]];
		NSIndexPath *indexPathLessThan = [[indexPath indexPathByRemovingLastIndex] indexPathByAddingIndex:[indexPath indexAtPosition:[indexPath length]-1]+1];
		NSUInteger removableRow = uiIndexPath.row + 1;
		while ([rowToIndexPath count] > uiIndexPath.row + 1 &&
			   NSOrderedAscending == [(NSIndexPath*)[rowToIndexPath objectAtIndex:uiIndexPath.row+1] compare:indexPathLessThan]) {
			PropertyListNode *descendantNode = [self nodeFromIndexPath:[rowToIndexPath objectAtIndex:uiIndexPath.row+1]];
			if (descendantNode.state == NODE_EXPANDED) {
				descendantNode.state = NODE_COLLAPSED;
			}
			[rowToIndexPath removeObjectAtIndex:uiIndexPath.row+1];
			[result addObject:[NSIndexPath indexPathForRow:removableRow++ inSection:0]];
		}
		parentNode.state = NODE_COLLAPSED;
		return result;
	}
}


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)uiIndexPath {
    PropertyListCell *cell = (PropertyListCell*)[super tableView:tableView cellForRowAtIndexPath:uiIndexPath];
	if (cell) {
		[cell setupFont];
		[cell setupFromNode:[self nodeFromIndexPath:[self indexPathFromUITableIndexPath:uiIndexPath]]];
		cell.viewController = self.viewController;
	}
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [rowToIndexPath count];
}


@end
