#import "ZBPewviewViewController.h"
#import "ZBAppDelegate.h"

@interface ZBPewviewViewController ()
{
	NSTimer *timer;
	UITouch *lastTouch;
}
@end

@implementation ZBPewviewViewController

- (void)dealloc
{
	[timer invalidate];
}

- (void)timerMethod:(NSTimer *)inTimer
{
	if ([self isViewLoaded]) {
		[self.previewView setNeedsDisplay];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (!timer) {
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
	}
	[(ZBAppDelegate *)[UIApplication sharedApplication].delegate canvasManager].delegate = self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark ZBPreviewViewDelegate

- (void)previewViewDidRequestDrawingFunction:(ZBPreviewView *)inView
{
	[[(ZBAppDelegate *)[UIApplication sharedApplication].delegate canvasManager] runJavaScriptDrawingFunction];
}

#pragma mark ZBCanvasManagerDelegate

- (CGPoint)canvasManagerRequestLastTouchLocation:(ZBCanvasManager *)manager
{
	return [lastTouch locationInView:self.previewView];
}

#pragma mark -
#pragma mark UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastTouch = [touches anyObject];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastTouch = [touches anyObject];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastTouch = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastTouch = [touches anyObject];
}

@end
