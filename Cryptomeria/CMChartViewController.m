//
//  CMFirstViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMChartViewController.h"

@interface CMChartViewController () <UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CMChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIView *shadowView in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if([shadowView isKindOfClass:[UIImageView class]]) {
            shadowView.hidden = YES;
        }
    }
    
    NSString *HTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chart" ofType:@"html"]  encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    [self.webView loadHTMLString:HTML baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
