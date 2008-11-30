//
//  LoadCellFromNibDataSource.h
//

#import <Foundation/Foundation.h>
#import "LoadCellFromNibDataSource.h"


@interface LoadCellFromNibDataSource : NSObject<UITableViewDataSource> {
	UITableViewCell *cellFromNib;
	NSString *nibIdentifier;
}

@property (nonatomic,assign) IBOutlet UITableViewCell *cellFromNib;
@property (nonatomic,retain) NSString *nibIdentifier;

- (id)init;
- (id)initWithNibIdentifier:(NSString*)identifier;

@end
