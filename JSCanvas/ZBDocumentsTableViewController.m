#import "ZBDocumentsTableViewController.h"
#import "ZBJavaScriptDocument.h"
#import "ZBSourceEditorViewController.h"

@interface ZBDocumentsTableViewController ()
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

- (IBAction)createNewDocument:(id)sender
{
	[ZBJavaScriptDocument createNewDocument];
	[self _loadFiles];
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

@end
