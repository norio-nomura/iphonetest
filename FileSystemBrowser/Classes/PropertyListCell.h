//
//  PropertyListCell.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>

@class PropertyListViewController;
@class PropertyListNode;

@interface PropertyListCell : UITableViewCell {
	UIButton *indicator;
	UILabel *key;
	UILabel *value;
	PropertyListViewController *viewController;
}

@property (nonatomic,retain) IBOutlet UIButton *indicator;
@property (nonatomic,retain) IBOutlet UILabel *key;
@property (nonatomic,retain) IBOutlet UILabel *value;
@property (nonatomic,assign) PropertyListViewController *viewController;

- (void)setupFont;
- (void)setupFromNode:(PropertyListNode*)node;
- (IBAction)indicatorPushed:(id)sender;

@end
