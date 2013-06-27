#import "ZBAppDelegate.h"
#import "ZBDocumentsTableViewController.h"

@implementation ZBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	ZBDocumentsTableViewController *documentsController = [[ZBDocumentsTableViewController alloc] initWithStyle:UITableViewStylePlain];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:documentsController];
	self.navigationController.toolbarHidden = NO;
	self.window.rootViewController = self.navigationController;
	[self.window setTintColor:[UIColor colorWithHue:0.1 saturation:1.0 brightness:0.5 alpha:1.0]];
	[self.window makeKeyAndVisible];

	NSString *key = @"WelcomeMessageEverShown";
	if (![[NSUserDefaults standardUserDefaults] boolForKey:key]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome to JSCanvas!", @"") message:NSLocalizedString(@"JSCanvas is a Processing-inspired iOS app. It let you create cool scripts running on your device using JavaScript language. Enjoy it!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles: nil];
		[alertView show];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

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

@end
