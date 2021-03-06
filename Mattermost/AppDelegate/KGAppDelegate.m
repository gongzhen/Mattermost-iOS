//
//  KGAppDelegate.m
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGPreferences.h"
#import "KGSideMenuContainerViewController.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Notifications.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "KGBusinessLogic+Session.h"
#import "KGNotificationValues.h"
#import "KGDrawer.h"
#import "KGHardwareUtils.h"

@interface KGAppDelegate ()
@end

@implementation KGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self instantiateSingletons];
    [self loadInitialScreen];
    [self setupKeyboardManager];
    [self registerForRemoteNotifications];
    [self setupFabric];
    [self sendLaunchNotificationWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[KGPreferences sharedInstance] save];
    [[NSManagedObjectContext MR_defaultContext].parentContext MR_saveToPersistentStoreAndWait];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationDidReceiveRemoteNotification object:userInfo];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[KGBusinessLogic sharedInstance] saveNotificationsToken:deviceToken];
}
#pragma mark - Private

- (void)loadInitialScreen {
    if ([[KGBusinessLogic sharedInstance] isSignedIn]) {
        KGSideMenuContainerViewController *sideMenuContainer = [KGSideMenuContainerViewController configuredContainerViewController];
        self.window.rootViewController = sideMenuContainer;
        _menuContainerViewController = sideMenuContainer;
        [self.window makeKeyAndVisible];
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *navController = [sb instantiateInitialViewController];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    }
}

- (void)instantiateSingletons {
    [KGDrawer sharedInstance];
    [KGPreferences sharedInstance];
    [KGHardwareUtils sharedInstance];
}

- (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];
}

- (void)setupKeyboardManager {
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[UIViewController class]];
}

- (void)registerForRemoteNotifications {
    [[KGBusinessLogic sharedInstance] registerForRemoteNotifications];
}

- (void)sendLaunchNotificationWithOptions:(NSDictionary* )options {
    [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationDidFinishLaunching object:options];
}

@end
