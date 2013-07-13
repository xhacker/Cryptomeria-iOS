//
//  CMFirstViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMChartViewController.h"

@interface CMChartViewController () <UITableViewDataSource, UIWebViewDelegate>

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
    
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    NSString *HTML = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chart" ofType:@"html"]  encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    [self.webView loadHTMLString:HTML baseURL:baseURL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    const double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.webView.backgroundColor = [UIColor whiteColor];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
