//
//  CMAppDelegate.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMAppDelegate.h"
#import "TestFlight.h"
#import "UIImage+Device.h"

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"a2473b66-161c-4b7e-9e00-5cdbd04208dd"];
    
    CGRect screenRect;
    UIImage *splashImage;
    if (isPhone) {
        screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568) {
            splashImage = [UIImage imageNamed:@"Default-568h"];
        }
        else {
            splashImage = [UIImage imageNamed:@"Default"];
        }
    }
    else {
        // iPad
        if (isPortrait) {
            splashImage = [UIImage imageNamed:@"Default-Portrait"];
            if (isPortraitUp) {
                screenRect = CGRectMake(0, 20, 768, 1004);
            }
            else {
                screenRect = CGRectMake(0, 0, 768, 1004);
                splashImage = [[UIImage alloc] initWithCGImage:splashImage.CGImage
                                                         scale:1.0
                                                   orientation:UIImageOrientationDown];
            }
        }
        else {
            UIImage *originalImage = [UIImage imageNamed:@"Default-Landscape"];
            if (isLandscapeLeft) {
                screenRect = CGRectMake(20, 0, 748, 1024);
                splashImage = [[UIImage alloc] initWithCGImage:originalImage.CGImage
                                                         scale:1.0
                                                   orientation:UIImageOrientationLeft];
            }
            else {
                screenRect = CGRectMake(0, 0, 748, 1024);
                splashImage = [[UIImage alloc] initWithCGImage:originalImage.CGImage
                                                         scale:1.0
                                                   orientation:UIImageOrientationRight];
            }
        }
    }
    self.splashView = [[UIImageView alloc] initWithFrame:screenRect];
    self.splashView.image = splashImage;

    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
