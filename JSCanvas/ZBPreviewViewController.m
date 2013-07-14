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

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imageView.backgroundColor = [UIColor whiteColor];
	imageView.alpha = 0.2;
	self.backgroundImageView = imageView;
	[self.view addSubview:self.backgroundImageView];

	ZBPreviewView *previewView = [[ZBPreviewView alloc] initWithFrame:self.view.bounds];
	previewView.backgroundColor = [UIColor clearColor];
	previewView.clipsToBounds = NO;
	previewView.layer.masksToBounds = NO;
	previewView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.previewView = previewView;
	self.previewView.delegate = self;
	[self.view addSubview:self.previewView];

	UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	interpolationHorizontal.minimumRelativeValue = @-20.0;
	interpolationHorizontal.maximumRelativeValue = @20.0;

	UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	interpolationVertical.minimumRelativeValue = @-20.0;
	interpolationVertical.maximumRelativeValue = @20.0;

	[self.previewView addMotionEffect:interpolationHorizontal];
	[self.previewView addMotionEffect:interpolationVertical];

	UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stop", @"") style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
	self.navigationItem.rightBarButtonItem = closeItem;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSUInteger option = UIExtendedEdgeLeft | UIExtendedEdgeBottom | UIExtendedEdgeRight;
	[self setEdgesForExtendedLayout:option];

	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.previewView addGestureRecognizer:tapGR];

	UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.previewView addGestureRecognizer:leftSwipeGR];

	UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
	[self.previewView addGestureRecognizer:rightSwipeGR];

	UISwipeGestureRecognizer *upSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
	[self.previewView addGestureRecognizer:upSwipeGR];

	UISwipeGestureRecognizer *downSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
	[self.previewView addGestureRecognizer:downSwipeGR];


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
	[self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -

- (void)tap:(UITapGestureRecognizer *)tapGR
{
	CGPoint point = [tapGR locationInView:tapGR.view];
	[canvasManager runJavaScriptTapFunctionWithLocation:point];
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGR
{
	UISwipeGestureRecognizerDirection direction = swipeGR.direction;
	[canvasManager runJavaScriptSwipeFunctionWithDirection:direction];
}


#pragma mark ZBPreviewViewDelegate

- (void)previewViewDidRequestDrawingFunction:(ZBPreviewView *)inView
{
	if (!self.backgroundImageView.image) {
		return;
	}
	[canvasManager runJavaScriptDrawingFunction];
}

@end
