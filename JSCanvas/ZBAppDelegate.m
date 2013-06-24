#import "ZBAppDelegate.h"
#import "ZBSourceEditorViewController.h"

@implementation ZBAppDelegate
{
	ZBCanvasManager *canvasManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	canvasManager = [[ZBCanvasManager alloc] init];
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	ZBSourceEditorViewController *sourceEditorViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"sourceEditor"];
	[sourceEditorViewController view];
	NSString *sampleScript = sourceEditorViewController.currentScript;
	[canvasManager loadJavaScript:sampleScript];
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@synthesize window;
@synthesize canvasManager;

@end
