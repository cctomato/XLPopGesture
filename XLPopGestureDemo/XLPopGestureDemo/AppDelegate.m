//
//  AppDelegate.m
//  XLPopGestureDemo
//
//  Created by cai cai on 2017/3/30.
//  Copyright © 2017年 cai cai. All rights reserved.
//

#import "AppDelegate.h"
#import "XLOneViewController.h"
#import "UINavigationController+XLPopGesture.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[XLOneViewController alloc] init]];
    nav1.tabBarItem.title = @"首页1";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabbar_selected"];
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBar addChildViewController:nav1];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[XLOneViewController alloc] init]];
    nav2.xl_prefersHiddenTabBar = NO;
    nav2.tabBarItem.title = @"首页2";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabbar_selected"];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBar addChildViewController:nav2];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[XLOneViewController alloc] init]];
    nav3.xl_prefersOpenBackEffects = NO;
    nav3.tabBarItem.title = @"首页3";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabbar_selected"];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBar addChildViewController:nav3];
    
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:[[XLOneViewController alloc] init]];
    nav4.xl_prefersHiddenTabBar = NO;
    nav4.xl_prefersOpenBackEffects = NO;
    nav4.tabBarItem.title = @"首页4";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabbar_selected"];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBar addChildViewController:nav4];
    
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
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
}


@end
