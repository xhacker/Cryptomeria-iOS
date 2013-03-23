//
//  CMFirstViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMChartViewController.h"
#import "CMChartData.h"
#import "CMChartCell.h"

@interface CMChartViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CMChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    //    if (cell == nil) {
//        cell = [[CMChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChartCell"];
//    }
    
    cell.kanaTitleLabel.text = [CMChartData hiragana][indexPath.row][0];
	cell.romajiTitleLabel.text = [CMChartData romaji][indexPath.row][0];
    
    return cell;
}

@end
