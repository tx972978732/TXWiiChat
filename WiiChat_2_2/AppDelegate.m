//
//  AppDelegate.m
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "AppDelegate.h"
#import "WCBaseTabBarViewController.h"
#import "WCBaseNavigationController.h"
#import "LoginViewController.h"
#import "WCMessageRootTableViewController.h"
#import "WCContactRootTableViewController.h"
#import "WCDiscoverRootTableViewController.h"
#import "WCProfileRootTableViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    application.applicationSupportsShakeToEdit = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        WCMessageRootTableViewController *messageVC = [[WCMessageRootTableViewController alloc]init];
        messageVC.title = NSLocalizedStringFromTable(@"WiiChat", @"WCLocalizable", @"微信");//本地化
        
        WCBaseNavigationController *messageNC = [[WCBaseNavigationController alloc]initWithRootViewController:messageVC];

        WCContactRootTableViewController *contactVC = [[WCContactRootTableViewController alloc]init];
         contactVC.title = NSLocalizedStringFromTable(@"Contact", @"WCLocalizable", @"通讯录");
        WCBaseNavigationController *contactNC = [[WCBaseNavigationController alloc]initWithRootViewController:contactVC];
        
        WCDiscoverRootTableViewController *discoverVC = [[WCDiscoverRootTableViewController alloc]init];
        discoverVC.title = NSLocalizedStringFromTable(@"Discovery", @"WCLocalizable", @"发现");
        WCBaseNavigationController *discoverNC = [[WCBaseNavigationController alloc]initWithRootViewController:discoverVC];
        
        WCProfileRootTableViewController *profileVC = [[WCProfileRootTableViewController alloc]init];
        profileVC.title = NSLocalizedStringFromTable(@"Profile", @"WCLocalizable", @"我");
        WCBaseNavigationController *profileNC = [[WCBaseNavigationController alloc]initWithRootViewController:profileVC];
        
        WCBaseTabBarViewController *rootTB = [[WCBaseTabBarViewController alloc]init];
        rootTB.viewControllers = [NSArray arrayWithObjects:messageNC,contactNC,discoverNC,profileNC, nil];
        self.window.rootViewController = rootTB;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        WCBaseNavigationController *loginNC = [[WCBaseNavigationController alloc]initWithRootViewController:loginVC];
        [loginNC.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        [loginNC.navigationBar setShadowImage:[[UIImage alloc]init]];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:253.0f/255.0f green:210.0f/255.0f blue:71.0f/255.0f alpha:1.0]];
        loginNC.automaticallyAdjustsScrollViewInsets = NO;
        self.window.rootViewController = loginNC;
    }
    //监听网络状态
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
   
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)switchRootViewController{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        WCMessageRootTableViewController *messageVC = [[WCMessageRootTableViewController alloc]init];
        messageVC.title = NSLocalizedStringFromTable(@"WiiChat", @"WCLocalizable", @"微信");//本地化
        
        WCBaseNavigationController *messageNC = [[WCBaseNavigationController alloc]initWithRootViewController:messageVC];
        
        WCContactRootTableViewController *contactVC = [[WCContactRootTableViewController alloc]init];
        contactVC.title = NSLocalizedStringFromTable(@"Contact", @"WCLocalizable", @"通讯录");
        WCBaseNavigationController *contactNC = [[WCBaseNavigationController alloc]initWithRootViewController:contactVC];
        
        WCDiscoverRootTableViewController *discoverVC = [[WCDiscoverRootTableViewController alloc]init];
        discoverVC.title = NSLocalizedStringFromTable(@"Discovery", @"WCLocalizable", @"发现");
        WCBaseNavigationController *discoverNC = [[WCBaseNavigationController alloc]initWithRootViewController:discoverVC];
        
        WCProfileRootTableViewController *profileVC = [[WCProfileRootTableViewController alloc]init];
        profileVC.title = NSLocalizedStringFromTable(@"Profile", @"WCLocalizable", @"我");
        WCBaseNavigationController *profileNC = [[WCBaseNavigationController alloc]initWithRootViewController:profileVC];
        
        WCBaseTabBarViewController *rootTB = [[WCBaseTabBarViewController alloc]init];
        rootTB.viewControllers = [NSArray arrayWithObjects:messageNC,contactNC,discoverNC,profileNC, nil];
        self.window.rootViewController = rootTB;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        WCBaseNavigationController *loginNC = [[WCBaseNavigationController alloc]initWithRootViewController:loginVC];
        [loginNC.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        [loginNC.navigationBar setShadowImage:[[UIImage alloc]init]];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:253.0f/255.0f green:210.0f/255.0f blue:71.0f/255.0f alpha:1.0]];
        loginNC.automaticallyAdjustsScrollViewInsets = NO;
        self.window.rootViewController = loginNC;
    }

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}
#pragma mark - UIStateRestoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

//#pragma mark - Core Data stack
//
//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"WiiChat_2_2"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//    
//    return _persistentContainer;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}

@end
