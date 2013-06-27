#import "ZBPreviewViewController.h"

@interface ZBPreviewViewController ()
{
	NSTimer *timer;
	ZBCanvasManager *canvasManager;
}
@end

@implementation ZBPreviewViewController

- (void)dealloc
{
	[timer invalidate];
}

- (instancetype)initWithJavaScript:(NSString *)inJavaScript
{
	self = [super init];
	if (self) {
		canvasManager = [[ZBCanvasManager alloc] init];
		canvasManager.delegate = self;
		[canvasManager loadJavaScript:inJavaScript];
	}
	return self;
}

- (void)timerMethod:(NSTimer *)inTimer
{
	if ([self isViewLoaded]) {
		[self.previewView setNeedsDisplay];
	}
}

- (void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;

	ZBPreviewView *previewView = [[ZBPreviewView alloc] initWithFrame:self.view.bounds];
	previewView.backgroundColor = [UIColor whiteColor];
	previewView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.previewView = previewView;
	self.previewView.delegate = self;
	[self.view addSubview:self.previewView];

	UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
	self.navigationItem.leftBarButtonItem = closeItem;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSUInteger option = UIExtendedEdgeLeft | UIExtendedEdgeBottom | UIExtendedEdgeRight;
	[self setEdgesForExtendedLayout:option];

	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.previewView addGestureRecognizer:tapGR];

	if (!timer) {
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Interface Builder actions

- (IBAction)close:(id)sender
{
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)tap:(UITapGestureRecognizer *)tapGR
{
	CGPoint point = [tapGR locationInView:tapGR.view];
	[canvasManager runJavaScriptTapFunctionWithLocation:point];
}

#pragma mark ZBPreviewViewDelegate

- (void)previewViewDidRequestDrawingFunction:(ZBPreviewView *)inView
{
	[canvasManager runJavaScriptDrawingFunction];
}

@end
