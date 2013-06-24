#import "ZBSourceEditorViewController.h"
#import "ZBAppDelegate.h"

@interface ZBSourceEditorViewController ()
@end

@implementation ZBSourceEditorViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
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

@end
