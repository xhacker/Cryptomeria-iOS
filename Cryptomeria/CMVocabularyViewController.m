//
//  CMVocabularyViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMVocabularyViewController.h"
#import "CMVocabularyData.h"

@interface CMVocabularyViewController ()

@end

@implementation CMVocabularyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [CMVocabularyData vocabulary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
