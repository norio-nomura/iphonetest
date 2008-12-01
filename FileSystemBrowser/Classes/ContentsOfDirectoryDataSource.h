//
//  ContentsOfDirectoryDataSource.h
//  FileSystemBrowser
//

#import <Foundation/Foundation.h>
#import "IndexedDataSource.h"

@interface ContentsOfDirectoryDataSource : IndexedDataSource {
	NSString *path;
}

@property (nonatomic,copy) NSString *path;

- (id)initWithPath:(NSString*)aPath;

@end
