#import "ZBSamplesTableViewController.h"

@interface ZBSamplesTableViewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
	NSArray *files;
	QLPreviewController *previewController;
}
@end

@implementation ZBSamplesTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (!previewController) {
		previewController = [[QLPreviewController alloc] init];
		previewController.dataSource = self;
		previewController.delegate = self;
	}

	NSString *sampleFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"];
	NSDirectoryEnumerator *e = [[NSFileManager defaultManager] enumeratorAtPath:sampleFolderPath];
	NSMutableArray *sampleFiles = [NSMutableArray array];
	NSString *sampleFile = nil;
	while (sampleFile = [e nextObject]) {
		[sampleFiles addObject:sampleFile];
	}
	files = sampleFiles;

	self.title = NSLocalizedString(@"Samples", @"");
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelItem;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender
{
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = [files[indexPath.row] stringByDeletingPathExtension];;
	cell.imageView.image = [UIImage imageNamed:@"doc"];
	cell.accessoryType = UITableViewCellAccessoryDetailButton;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *filename = files[indexPath.row];
	NSString *sampleFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"];
	NSString *fullPath = [sampleFolderPath stringByAppendingPathComponent:filename];
	NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
	[self.delegate samplesTableViewController:self didSelectFileAtURL:fileURL];
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	previewController.currentPreviewItemIndex = indexPath.row;
	NSUInteger option = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
	[previewController setEdgesForExtendedLayout:option];
	[self.navigationController pushViewController:previewController animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
	return [files count];
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
	NSString *filename = files[index];
	NSString *sampleFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"];
	NSString *fullPath = [sampleFolderPath stringByAppendingPathComponent:filename];
	NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
	return fileURL;
}


@end
