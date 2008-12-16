//
//  MachOFileSymbolsViewController.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>
#import "IndexedDataSource.h"

NSArray* MachOFileSymbolsCreate(NSString* filename);

@interface NSObject(MachOFileSymbolsViewController)
- (NSString*)firstTwoChar;
@end

@interface MachOFileSymbolsViewController : UIViewController<UITableViewDelegate> {
	UITableView *tableView;
	NSString *path;
	NSArray *symbols;
	IndexedDataSource *machOFileSymbols;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSArray *symbols;
@property (nonatomic,retain) IndexedDataSource *machOFileSymbols;

@end
