//
//  CMTabBarController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-05-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMTabBarController.h"

@interface CMTabBarController ()

@end

@implementation CMTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBar.items[0] setFinishedSelectedImage:[UIImage imageNamed:@"icon-chart-highlight"]
                       withFinishedUnselectedImage:nil];
    [self.tabBar.items[1] setFinishedSelectedImage:[UIImage imageNamed:@"icon-test-highlight"]
                       withFinishedUnselectedImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
