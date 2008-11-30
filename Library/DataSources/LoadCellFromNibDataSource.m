//
//  LoadCellFromNibDataSource.m
//

#import "LoadCellFromNibDataSource.h"
#import "CellFromNib.h"


@implementation LoadCellFromNibDataSource

@synthesize cellFromNib;
@synthesize nibIdentifier;


- (id)init {
	return [self initWithNibIdentifier:NSStringFromClass([LoadCellFromNibDataSource class])];
}


- (id)initWithNibIdentifier:(NSString*)identifier {
	if (self = [super init]) {
		self.nibIdentifier = identifier;
	}
	return self;
}


- (void)dealloc {
	[nibIdentifier release];
    [super dealloc];
}


#pragma mark UITableViewDataSource Protocol


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:self.nibIdentifier owner:self options:nil];
		cell = self.cellFromNib;
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}


@end
