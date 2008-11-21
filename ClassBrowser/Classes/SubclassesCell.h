//
//  SubclassesCell.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>


@interface SubclassesCell : UITableViewCell {
	UILabel *subclassName;
	UILabel *imagePath;
}

@property (nonatomic,retain) IBOutlet UILabel *subclassName;
@property (nonatomic,retain) IBOutlet UILabel *imagePath;

@end
