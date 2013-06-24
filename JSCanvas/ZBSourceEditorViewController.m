#import "ZBSourceEditorViewController.h"
#import "ZBAppDelegate.h"

@interface ZBSourceEditorViewController ()
@end

@implementation ZBSourceEditorViewController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		NSUInteger option = UIExtendedEdgeLeft | UIExtendedEdgeBottom | UIExtendedEdgeRight;
		[self setEdgesForExtendedLayout:option];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	NSURL *sampleFileURL = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"js"];
	NSString *sampleScript = [NSString stringWithContentsOfURL:sampleFileURL encoding:NSUTF8StringEncoding error:nil];
	self.currentScript = sampleScript;
	self.textView.text = self.currentScript;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)update:(id)sender
{
	[self.textView resignFirstResponder];
	NSString *script = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	self.currentScript = script;
	[[(ZBAppDelegate *)[UIApplication sharedApplication].delegate canvasManager] loadJavaScript:self.currentScript];
}

- (IBAction)cancel:(id)sender
{
	[self.textView resignFirstResponder];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)n
{
	CGRect textFrame = self.textView.frame;
	textFrame.size.height = [self.textView convertRect:[[n userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil].origin.y;
	self.textView.frame = textFrame;
}

- (void)keyboardWillHide:(NSNotification *)n
{
	self.textView.frame = self.view.bounds;
}


@end
