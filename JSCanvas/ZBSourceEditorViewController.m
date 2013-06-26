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

	UIBarButtonItem *runItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Run", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(run:)];
	self.navigationItem.rightBarButtonItem = runItem;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	self.textView.text = self.document.text;
	self.title = [[self.document.fileURL path] lastPathComponent];
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
	controller.title = self.title;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[self.navigationController presentViewController:navController animated:YES completion:nil];
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
	[self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

@synthesize document;

@end
