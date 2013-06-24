#import "ZBPewviewViewController.h"
#import "ZBAppDelegate.h"

@interface ZBPewviewViewController ()
{
	NSTimer *timer;
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
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)previewViewDidRequestDrawingFunction:(ZBPreviewView *)inView
{
	[[(ZBAppDelegate *)[UIApplication sharedApplication].delegate canvasManager] runJavaScriptDrawingFunction];
}

@end
