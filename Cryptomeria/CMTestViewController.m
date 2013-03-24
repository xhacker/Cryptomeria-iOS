//
//  CMSecondViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMTestViewController.h"
#import "CMChartData.h"

@interface CMTestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *horkControl;
@property (weak, nonatomic) IBOutlet UIStepper *rangeStepper;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;

- (void)updateRangeLabel:(NSInteger)range;

@end

typedef enum {
    KanaRomaji = 0,
    RomajiKana,
} Direction;

typedef enum {
    Hiragana = 0,
    Katakana,
    Both,
} Hork;

@implementation CMTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger kanaRange = [defaults integerForKey:@"KanaRange"];
    [self updateRangeLabel:kanaRange];
    NSInteger direction = [defaults integerForKey:@"Direction"];
    [self.directionControl setSelectedSegmentIndex:direction];
    NSInteger hork = [defaults integerForKey:@"Hork"];
    [self.horkControl setSelectedSegmentIndex:hork];
}

- (IBAction)rangeChanged:(UIStepper *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(NSInteger)sender.value forKey:@"KanaRange"];
    [self updateRangeLabel:sender.value];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sender.selectedSegmentIndex forKey:@"Hork"];
}

- (void)updateRangeLabel:(NSInteger)range
{
    self.rangeLabel.text = [NSString stringWithFormat:@"あ-%@", [CMChartData hiragana][range][0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
