//
//  MachOFileSymbolsViewController.m
//  FileSystemBrowser
//

#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import "MachOFileSymbolsViewController.h"


NSArray* MachOFileSymbolsCreate(NSString* filename) {
	NSMutableArray *symbols = nil;
	NSData *data = nil;
	if (data = [[NSData alloc]initWithContentsOfMappedFile:filename]) {
		const struct mach_header *header = [data bytes];
		if (header->magic == MH_MAGIC) {
			const struct load_command *command = [data bytes]+sizeof(struct mach_header);
			for (uint32_t i = 0; i < header->ncmds; i++) {
				if (command->cmd == LC_SYMTAB) {
					const struct symtab_command *symtab = (const void*)command;
					const char *strings = [data bytes] + symtab->stroff;
					const struct nlist *nlist = [data bytes] + symtab->symoff;
					if (symtab->nsyms && !symbols) {
						symbols = [[NSMutableArray alloc]initWithCapacity:symtab->nsyms];
					}
					for (uint32_t j = 0; j < symtab->nsyms; j++) {
						NSString *symbol = [[NSString alloc]initWithCString:strings + nlist[j].n_un.n_strx encoding:NSNEXTSTEPStringEncoding];
						if ([symbol length]) {
							[symbols addObject:symbol];
						}
						[symbol release];
					}
				}
				command = (const void*)command + command->cmdsize;
			}
		}
		[data release];
	}
	return symbols;
}


@implementation NSObject(MachOFileSymbolsViewController)


- (NSString*)firstTwoChar {
	return [[self description] substringToIndex:2];
}


@end

@implementation MachOFileSymbolsViewController

@synthesize tableView;
@synthesize path;
@synthesize symbols;
@synthesize machOFileSymbols;


- (void)setPath:(NSString*)obj {
	if (path != obj) {
		[path release];
		path = [obj retain];
		self.title = [path lastPathComponent];
	}
}


- (void)dealloc {
	[tableView release];
	[path release];
	[symbols release];
	[machOFileSymbols release];
	[super dealloc];
}


#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	IndexedDataSource* dataSource = [[IndexedDataSource alloc] initWithArray:symbols usingSelector:@selector(firstTwoChar)];
	self.machOFileSymbols = dataSource;
	[dataSource release];
	tableView.dataSource = self.machOFileSymbols;
	[tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


#pragma mark UITableViewDelegate


@end
