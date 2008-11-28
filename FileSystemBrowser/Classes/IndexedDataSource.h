//
//  IndexedDataSource.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>

@interface NSObject(indexedDictionary)
- (NSString*)capitalChar;
- (NSString*)firstChar;
@end

@interface NSDictionary(indexedDictionary)
- (id)initIndexedDictionaryWithArray:(NSArray*)array usingSelector:(SEL)aSel;
@end

@interface IndexedDataSource : NSObject<UITableViewDataSource> {
	NSArray *sectionTitles;
	NSDictionary *rows;
	UITableViewCell *cellFromNib;
	@private
	SEL selectorForIndex;
}

@property (nonatomic,retain) NSArray *sectionTitles;
@property (nonatomic,retain) NSDictionary *rows;
@property (nonatomic,assign) IBOutlet UITableViewCell *cellFromNib;

- (id)initWithArray:(NSArray*)array;
- (id)initWithArray:(NSArray*)array usingSelector:(SEL)aSel;
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForObject:(id)obj;

@end
