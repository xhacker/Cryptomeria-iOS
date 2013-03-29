//
//  CMVocabularyViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMVocabularyViewController.h"
#import "CMVocabularyData.h"
#import "CMVocabularyCell.h"
#import "CMChartData.h"

@interface CMVocabularyViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *vocabulary;
@property NSArray *hiragana;

@end

@implementation CMVocabularyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vocabulary = [CMVocabularyData vocabulary];
    self.hiragana = [CMChartData hiragana];
    
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.vocabulary.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.hiragana[section][0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.vocabulary[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMVocabularyCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"VocabularyCell"];
    
    cell.kanaLabel.text = self.vocabulary[indexPath.section][indexPath.row][@"kana"];
    cell.meaningLabel.text = self.vocabulary[indexPath.section][indexPath.row][@"meaning"];
    
    return cell;
}

@end
