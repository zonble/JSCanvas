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
	[self.window makeKeyAndVisible];
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
