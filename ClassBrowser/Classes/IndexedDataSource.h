//
//  IndexedDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>


@interface NSObject(indexedDictionary)
- (NSString*)capitalChar;
@end


@interface NSArray(indexedDictionary)
- (NSDictionary*)indexedDictionaryWithIndexSelector:(SEL)aSel;
- (NSDictionary*)capitalCharIndexedDictionary;
@end


@interface IndexedDataSource : NSObject<UITableViewDataSource> {
	NSString *name;
	NSArray *sectionIndexTitles;
	NSDictionary *rows;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSArray *sectionIndexTitles;
@property (nonatomic,retain) NSDictionary *rows;

- (id)initWithArray:(NSArray*)array;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForObject:(id)obj;

@end
