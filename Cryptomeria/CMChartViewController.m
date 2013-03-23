//
//  CMFirstViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CMChartViewController.h"
#import "CMChartData.h"
#import "CMChartCell.h"

@interface CMChartViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *romajiData;
@property NSArray *hiraganaData;
@property NSArray *katakanaData;

@end

@implementation CMChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.romajiData = [CMChartData romaji];
    self.hiraganaData = [CMChartData hiragana];
    self.katakanaData = [CMChartData katakana];
    
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CMChartData romaji] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell"];
    
    cell.kanaTitleLabel.text = self.hiraganaData[indexPath.row][0];
	cell.romajiTitleLabel.text = self.romajiData[indexPath.row][0];
    for (NSInteger i = 0; i < 5; ++i) {
        ((UILabel *)cell.hiraganaLabels[i]).text = self.hiraganaData[indexPath.row][i];
        ((UILabel *)cell.katakanaLabels[i]).text = self.katakanaData[indexPath.row][i];
        ((UILabel *)cell.romajiLabels[i]).text = self.romajiData[indexPath.row][i];
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

@end
