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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;

@property NSUserDefaults *defaults;
@property NSMutableArray *sequence;
@property NSInteger prevHork;

- (void)updateRangeLabel:(NSInteger)range;
- (void)generateSequence;
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
    
    self.prevHork = Katakana;
    [self generateSequence];
    [self next];
}

- (void)generateSequence
{
    self.sequence = [[NSMutableArray alloc] init];
    NSInteger kanaRange = [self.defaults integerForKey:@"KanaRange"];
    NSInteger last = ((NSNumber *)[CMChartData lastInRow][kanaRange]).integerValue;
    
    for (NSInteger i = 0; i <= last; ++i) {
        [self.sequence addObject:@(i)];
    }
    
    [self.sequence shuffle];
}

- (void)next
{
    NSInteger hork = [self.defaults integerForKey:@"Hork"];
    NSInteger direction = [self.defaults integerForKey:@"Direction"];
    
    NSArray *flattenedRomaji = [[CMChartData romaji] flatten];
    NSArray *flattenedHiragana = [[CMChartData hiragana] flatten];
    NSArray *flattenedKatakana = [[CMChartData katakana] flatten];
    
    if (self.sequence.count == 0) {
        [self generateSequence];
    }
    
    NSInteger thisID = [((NSNumber *)[self.sequence lastObject]) integerValue];
    [self.sequence removeLastObject];
    
    NSInteger thisHork = hork;
    if (hork == Both) {
        thisHork = (self.prevHork == Hiragana) ? Katakana : Hiragana;
        self.prevHork = thisHork;
    }
    
    // main label
    if (direction == RomajiKana) {
        self.mainKanaLabel.text = flattenedRomaji[thisID];
    }
    else if (thisHork == Hiragana) {
        self.mainKanaLabel.text = flattenedHiragana[thisID];
    }
    else if (thisHork == Katakana) {
        self.mainKanaLabel.text = flattenedKatakana[thisID];
    }
    
    
    // place options
    //    var option_range = get_section_range_by_id(kana_id);
    //    if (option_range.end > kana_range - 1) {
    //        option_range.end = kana_range - 1;
    //    }
//    NSArray *optionBase = [CMChartData romaji];
//    NSInteger rightOption = arc4random() % 4;
//    [self.optionButtons[rightOption] setTitle:kana forState:UIControlStateNormal];
//    NSMutableArray *usedKana = [[NSMutableArray alloc] initWithObjects:kana, nil];
//
//    
//    for (NSInteger i = 0; i <= 3; ++i) {
//        if (i == rightOption) {
//            continue;
//        }
//        NSString *optionText;
//        do {
//            // TODO
//            optionText = optionBase[arc4random() % optionBase.count][0];
//        } while ([usedKana containsObject:optionText] || kana.length == 0 || [kana hasPrefix:@"("]);
//        [usedKana addObject:optionText];
//        [self.optionButtons[i] setTitle:optionText forState:UIControlStateNormal];
//    }
}

- (IBAction)rangeChanged:(UIStepper *)sender
{
    [self.defaults setInteger:(NSInteger)sender.value forKey:@"KanaRange"];
    [self updateRangeLabel:sender.value];
    [self generateSequence];
    [self next];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
    [self generateSequence];
    [self next];
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Hork"];
    [self generateSequence];
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
