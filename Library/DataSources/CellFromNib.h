//
//  CellFromNib.h
//

#import <UIKit/UIKit.h>

@interface CellFromNib : UITableViewCell {
	UILabel *label;
}

@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic,copy) NSString *text;

@end
