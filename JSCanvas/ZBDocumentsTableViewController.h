/*! The table view controller which lists all existing JavaScript documents. */

@interface ZBDocumentsTableViewController : UITableViewController
	<UIActionSheetDelegate>

- (IBAction)createNewDocument:(id)sender;
- (IBAction)loadSamples:(id)sender;
- (IBAction)showMore:(id)sender;

@end
