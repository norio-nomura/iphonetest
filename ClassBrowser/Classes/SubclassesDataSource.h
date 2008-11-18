//
//  SubclassesDataSource.h
//  ClassBrowser
//

#import <UIKit/UIKit.h>
#import "IndexedDataSource.h"
#import "SubclassesCell.h"


@interface SubclassesDataSource : IndexedDataSource {
	SubclassesCell *cellFromNib;
}


@property (nonatomic,retain) IBOutlet SubclassesCell *cellFromNib;


@end
