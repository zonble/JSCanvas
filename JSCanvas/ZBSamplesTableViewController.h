@class ZBSamplesTableViewController;

@protocol ZBSamplesTableViewControllerDelegate <NSObject>
- (void)samplesTableViewController:(ZBSamplesTableViewController *)inController didSelectFileAtURL:(NSURL *)inFileURL;
@end

@interface ZBSamplesTableViewController : UITableViewController
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) id <ZBSamplesTableViewControllerDelegate> delegate;
@end
