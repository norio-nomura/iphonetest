//
//  IndexedDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>


@interface NSObject(indexedDictionary)
- (NSString*)capitalChar;
@end

@interface NSDictionary(indexedDictionary)
- (id)initIndexedDictionaryWithArray:(NSArray*)array withSelector:(SEL)aSel;
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
- (id)initWithArray:(NSArray*)array withSelector:(SEL)aSel;
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForObject:(id)obj;

@end
