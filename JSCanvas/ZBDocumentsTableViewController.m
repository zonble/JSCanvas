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
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL];

//	UIBarButtonItem *importItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Import...", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(import:)];
//	UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
//	self.toolbarItems = @[importItem, spaceItem];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self _loadFiles];
	[self.tableView reloadData];
}

- (void)_loadFiles
{
	NSArray *files = [ZBJavaScriptDocument AllExistingFiles];
	self.files = files;
}

- (void)_loadDocument:(ZBJavaScriptDocument *)document
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[document openWithCompletionHandler:^(BOOL success) {
		if (success) {
			ZBSourceEditorViewController *controller = [[ZBSourceEditorViewController alloc] initWithDocoment:document];
			[self.navigationController pushViewController:controller animated:YES];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to open the document!", @"") message:@"" delegate:Nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
			[alert show];
		}
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}];
}

- (IBAction)createNewDocument:(id)sender
{

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"New", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"New Document", @""), NSLocalizedString(@"Load Samples", @""), nil];
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)createNewDocumentFromTemplate:(id)sender
{
	ZBJavaScriptDocument *document = [ZBJavaScriptDocument createNewDocumentWithFileName:@"newscript"];
	[self _loadDocument:document];
	[self _loadFiles];
	[self.tableView reloadData];
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
			[self createNewDocumentFromTemplate:nil];
			break;
		case 1:
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
	cell.textLabel.text = [self.files[indexPath.row] stringByDeletingPathExtension];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = [UIImage imageNamed:@"doc"];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *filename = self.files[indexPath.row];
		NSURL *fileURL = [ZBJavaScriptDocument fileURLWithFileName:filename];
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
		[self _loadFiles];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
	}
}

#pragma mark -

- (void)samplesTableViewController:(ZBSamplesTableViewController *)inController didSelectFileAtURL:(NSURL *)inFileURL
{
	NSError *e;
	NSString *text = [NSString stringWithContentsOfURL:inFileURL encoding:NSUTF8StringEncoding error:&e];
	if (!e) {
		NSString *filename = [[[inFileURL path] lastPathComponent] componentsSeparatedByString:@"."][0];
		ZBJavaScriptDocument *document = [ZBJavaScriptDocument createNewDocumentWithFileName:filename];
		[document.text setString:text];
		[document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
		[self _loadDocument:document];
		[self _loadFiles];
		[self.tableView reloadData];
	}
}


@end
