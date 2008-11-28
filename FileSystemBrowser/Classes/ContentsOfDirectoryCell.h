//
//  ContentsOfDirectoryCell.h
//  FileSystemBrowser
//

#import <UIKit/UIKit.h>

@interface ContentsOfDirectoryCell : UITableViewCell {
	UILabel *mode;
	UILabel *nlink;
	UILabel *owner;
	UILabel *group;
	UILabel *name;
}

@property(nonatomic,retain) IBOutlet UILabel *mode;
@property(nonatomic,retain) IBOutlet UILabel *nlink;
@property(nonatomic,retain) IBOutlet UILabel *owner;
@property(nonatomic,retain) IBOutlet UILabel *group;
@property(nonatomic,retain) IBOutlet UILabel *name;

- (void)setupFont;

@end
