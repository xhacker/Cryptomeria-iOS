//
//  CMSecondViewController.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-22.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMTestViewController.h"
#import "CMChartData.h"
#import "NSMutableArray+Shuffling.h"

@interface CMTestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *horkControl;
@property (weak, nonatomic) IBOutlet UIStepper *rangeStepper;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainKanaLabel;

@property NSUserDefaults *defaults;
@property NSMutableArray *kanaList;

- (void)updateRangeLabel:(NSInteger)range;
- (void)generateKanaList;
- (void)next;

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
	
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger kanaRange = [self.defaults integerForKey:@"KanaRange"];
    [self.rangeStepper setValue:(double)kanaRange];
    [self updateRangeLabel:kanaRange];
    NSInteger direction = [self.defaults integerForKey:@"Direction"];
    [self.directionControl setSelectedSegmentIndex:direction];
    NSInteger hork = [self.defaults integerForKey:@"Hork"];
    [self.horkControl setSelectedSegmentIndex:hork];
    
    [self generateKanaList];
    [self next];
}

- (void)generateKanaList
{
    NSInteger kanaRange = [self.defaults integerForKey:@"KanaRange"];
    NSInteger hork = [self.defaults integerForKey:@"Hork"];
    
    self.kanaList = [[NSMutableArray alloc] init];
    NSArray *kanaBase;
    if (hork == Hiragana) {
        kanaBase = [[CMChartData hiragana] subarrayWithRange:NSMakeRange(0, kanaRange)];
    }
    else if (hork == Katakana) {
        kanaBase = [[CMChartData katakana] subarrayWithRange:NSMakeRange(0, kanaRange)];
    }
    else {
        kanaBase = [[[CMChartData hiragana] subarrayWithRange:NSMakeRange(0, kanaRange)]
                    arrayByAddingObjectsFromArray:
                    [[CMChartData katakana] subarrayWithRange:NSMakeRange(0, kanaRange)]];
    }
    
    for (NSArray *row in kanaBase) {
        for (NSString *kana in row) {
            if (kana.length > 0 && ![kana hasPrefix:@"("]) {
                [self.kanaList addObject:kana];
            }
        }
    }
    [self.kanaList shuffle];
}

- (void)next
{
    if (self.kanaList.count == 0) {
        [self generateKanaList];
    }
    
    NSString *kana = [self.kanaList lastObject];
    [self.kanaList removeLastObject];
    self.mainKanaLabel.text = kana;
}

- (IBAction)rangeChanged:(UIStepper *)sender
{
    [self.defaults setInteger:(NSInteger)sender.value forKey:@"KanaRange"];
    [self updateRangeLabel:sender.value];
    [self generateKanaList];
    [self next];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
    [self generateKanaList];
    [self next];
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Hork"];
    [self generateKanaList];
    [self next];
}

- (void)updateRangeLabel:(NSInteger)range
{
    self.rangeLabel.text = [NSString stringWithFormat:@"あ-%@", [CMChartData hiragana][range][0]];
}

- (IBAction)optionClicked:(UIButton *)sender {
    [self next];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
