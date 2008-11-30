//
//  IndexedDataSource.h
//

#import <UIKit/UIKit.h>
#import "LoadCellFromNibDataSource.h"

@interface NSObject(indexedDictionary)
- (NSString*)capitalChar;
- (NSString*)firstChar;
@end

@interface NSDictionary(indexedDictionary)
- (id)initIndexedDictionaryWithArray:(NSArray*)array usingSelector:(SEL)aSel;
@end

@interface IndexedDataSource : LoadCellFromNibDataSource {
	NSArray *sectionTitles;
	NSDictionary *rows;
	BOOL enableIndex;
	BOOL enableSectionTitles;
@private
	SEL selectorForIndex;
}

@property (nonatomic,retain) NSArray *sectionTitles;
@property (nonatomic,retain) NSDictionary *rows;
@property (nonatomic) BOOL enableIndex;
@property (nonatomic) BOOL enableSectionTitles;

- (id)initWithArray:(NSArray*)array;
- (id)initWithArray:(NSArray*)array usingSelector:(SEL)aSel;
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForObject:(id)obj;

@end
