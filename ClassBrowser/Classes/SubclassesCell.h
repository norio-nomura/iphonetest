//
//  SubclassesCell.h
//  ClassBrowser
//
//  Created by 野村 憲男 on 08/11/18.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubclassesCell : UITableViewCell {
	UILabel *subclassName;
	UILabel *imagePath;
}

@property (nonatomic,retain) IBOutlet UILabel *subclassName;
@property (nonatomic,retain) IBOutlet UILabel *imagePath;

@end
