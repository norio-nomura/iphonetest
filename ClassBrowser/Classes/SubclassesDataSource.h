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


@property (nonatomic,assign) IBOutlet SubclassesCell *cellFromNib;


@end
