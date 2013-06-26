#import "ZBDocumentsTableViewController.h"
#import "ZBJavaScriptDocument.h"
#import "ZBSourceEditorViewController.h"
#import "ZBSamplesTableViewController.h"

@interface ZBDocumentsTableViewController () <ZBSamplesTableViewControllerDelegate>
- (void)_loadFiles;
@property (retain, nonatomic) NSArray *files;
@end

@implementation ZBDocumentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Documents", @"The title of ZBDocumentsTableViewController.");
	UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewDocument:)];
	self.navigationItem.leftBarButtonItem = newItem;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	UIBarButtonItem *moreOptionItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"More", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreOptions:)];
	UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	self.toolbarItems = @[spaceItem, moreOptionItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self _loadFiles];
}

- (void)_loadFiles
{
	NSArray *files = [ZBJavaScriptDocument existingFiles];
	self.files = files;
	[self.tableView reloadData];
}

- (void)_loadDocument:(ZBJavaScriptDocument *)document
{
	[document openWithCompletionHandler:^(BOOL success) {
		if (success) {
			ZBSourceEditorViewController *controller = [[ZBSourceEditorViewController alloc] initWithDocoment:document];
			[self.navigationController pushViewController:controller animated:YES];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to open the document!", @"") message:@"" delegate:Nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
			[alert show];
		}
	}];
}

- (IBAction)createNewDocument:(id)sender
{
	ZBJavaScriptDocument *document = [ZBJavaScriptDocument createNewDocument];
	[self _loadDocument:document];
	[self _loadFiles];
}

- (IBAction)showMoreOptions:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"More Options", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Load Samples", @""), nil];
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)loadSamples:(id)sender
{
	ZBSamplesTableViewController *controller = [[ZBSamplesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[self.navigationController presentViewController:navController animated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[self loadSamples:nil];
			break;
		default:
			break;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = self.files[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *filename = self.files[indexPath.row];
	NSURL *fileURL = [ZBJavaScriptDocument fileURLWithFileName:filename];
	ZBJavaScriptDocument *document = [[ZBJavaScriptDocument alloc] initWithFileURL:fileURL];
	[self _loadDocument:document];
}

#pragma mark -

- (void)samplesTableViewController:(ZBSamplesTableViewController *)inController didSelectFileAtURL:(NSURL *)inFileURL
{
	NSError *e;
	NSString *text = [NSString stringWithContentsOfURL:inFileURL encoding:NSUTF8StringEncoding error:&e];
	if (!e) {
		ZBJavaScriptDocument *document = [ZBJavaScriptDocument createNewDocument];
		[document.text setString:text];
		[document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
		[self _loadDocument:document];
		[self _loadFiles];
	}
}


@end
