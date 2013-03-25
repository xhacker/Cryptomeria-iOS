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
    self.kanaList = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i <= kanaRange; ++i) {
        for (NSString *kana in [CMChartData hiragana][i]) {
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
    NSLog(@"%@", kana);
}

- (IBAction)rangeChanged:(UIStepper *)sender
{
    [self.defaults setInteger:(NSInteger)sender.value forKey:@"KanaRange"];
    [self updateRangeLabel:sender.value];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Hork"];
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
