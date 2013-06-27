#import "ZBSourceEditorViewController.h"
#import "ZBPreviewViewController.h"

@interface ZBSourceEditorViewController ()
{
	ZBJavaScriptDocument *document;
}
- (void)_saveDocument;
@end

@implementation ZBSourceEditorViewController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDocoment:(ZBJavaScriptDocument *)inDocument
{
	self = [super init];
	if (self) {
		document = inDocument;
	}
	return self;
}

- (void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;

	UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	textView.font = [UIFont fontWithName:@"Courier" size:12.0];
	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	self.textView = textView;
	[self.view addSubview:self.textView];

	UIBarButtonItem *runItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Run", @"") style:UIBarButtonItemStyleDone target:self action:@selector(run:)];
	self.navigationItem.rightBarButtonItem = runItem;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	self.textView.text = self.document.text;
//	self.title = [[[self.document.fileURL path] lastPathComponent] stringByDeletingPathExtension];
	UIBarButtonItem *moreOptionItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"More", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreOptions:)];
	UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	self.toolbarItems = @[spaceItem, moreOptionItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self _saveDocument];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)run:(id)sender
{
	[self.textView resignFirstResponder];
	NSString *script = self.textView.text;
	ZBPreviewViewController *controller = [[ZBPreviewViewController alloc] initWithJavaScript:script];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[controller view];
	controller.title = self.title;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[navController view];

	CGRect imageFrame = [self.view convertRect:controller.backgroundImageView.frame fromView:controller.view];
	UIGraphicsBeginImageContextWithOptions(imageFrame.size, YES, [UIScreen mainScreen].scale);
	imageFrame.origin.y -= 36;
	imageFrame.size.height += 36;
	[self.view drawViewHierarchyInRect:imageFrame];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	CIContext *context = [CIContext contextWithOptions:nil];
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setDefaults];
	[filter setValue:[[CIImage alloc] initWithImage:newImage] forKey:kCIInputImageKey];
	[filter setValue:@2.0f forKey:@"inputRadius"];
	CIImage *effectedImage = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:effectedImage fromRect:[effectedImage extent]];
	UIImage *finalImage = [UIImage imageWithCGImage:cgImage];

	controller.backgroundImageView.image = finalImage;

	[self.navigationController presentViewController:navController animated:NO completion:nil];

}

- (IBAction)showMoreOptions:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"More Options", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"JSCanvas API Reference", @""), nil];
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)showAPIReference:(id)sender
{
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)n
{
	CGRect textFrame = self.textView.frame;
	textFrame.size.height = [self.view convertRect:[[n userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil].origin.y;
	self.textView.frame = textFrame;
}

- (void)keyboardWillHide:(NSNotification *)n
{
	self.textView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark Privates

- (void)_saveDocument
{
	NSString *script = self.textView.text;
	[self.document.text setString:script];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^ (BOOL success){
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}];
}

@synthesize document;

@end
