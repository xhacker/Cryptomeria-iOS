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

@interface CMVocabularyViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *vocabulary;

@end

@implementation CMVocabularyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vocabulary = [CMVocabularyData vocabulary];
    
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.vocabulary[0]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMVocabularyCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"VocabularyCell"];
    
    cell.kanaLabel.text = self.vocabulary[0][indexPath.row][@"kana"];
    cell.meaningLabel.text = self.vocabulary[0][indexPath.row][@"meaning"];
    
    return cell;
}

@end
