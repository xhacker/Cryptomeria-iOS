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

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface CMTestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *horkControl;
@property (weak, nonatomic) IBOutlet UIStepper *rangeStepper;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainKanaLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property NSUserDefaults *defaults;
@property NSMutableArray *sequence;
@property NSInteger prevHork;
@property NSString *rightText;
@property UIButton *rightButton;
@property NSInteger correctCount;
@property NSInteger totalCount;
@property BOOL inGuess;

- (void)updateRangeLabel:(NSInteger)range;
- (void)generateSequence;
- (void)resetScore;
- (void)next;
- (void)changeMainFont;

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
    [self resetScore];
    [self changeMainFont];
    self.inGuess = YES;
    [self next];
}

- (void)generateSequence
{
    self.sequence = [[NSMutableArray alloc] init];
    NSUInteger kanaRange = [self.defaults integerForKey:@"KanaRange"];
    NSUInteger last = [CMChartData lastInRow:kanaRange];
    
    for (NSInteger i = 0; i <= last; ++i) {
        [self.sequence addObject:@(i)];
    }
    
    [self.sequence shuffle];
}

- (void)resetScore
{
    self.correctCount = 0;
    self.totalCount = 0;
    self.scoreLabel.hidden = YES;
}

- (void)next
{
    NSInteger hork = [self.defaults integerForKey:@"Hork"];
    NSInteger direction = [self.defaults integerForKey:@"Direction"];
    NSInteger kanaRange = [self.defaults integerForKey:@"KanaRange"];
    
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
    
    CMSection section = [CMChartData getSection:thisID];
    NSUInteger lastInRange = [CMChartData lastInRow:kanaRange];
    if (section.last > lastInRange) {
        section.last = lastInRange;
    }
 
    NSInteger rightOption = arc4random() % 4;
    if (direction == KanaRomaji) {
        self.rightText = flattenedRomaji[thisID];
    }
    else if (thisHork == Hiragana) {
        self.rightText = flattenedHiragana[thisID];
    }
    else if (thisHork == Katakana) {
        self.rightText = flattenedKatakana[thisID];
    }
    [self.optionButtons[rightOption] setTitle:self.rightText forState:UIControlStateNormal];
    self.rightButton = self.optionButtons[rightOption];
    NSMutableArray *usedID = [[NSMutableArray alloc] initWithObjects:@(thisID), nil];

    for (NSInteger i = 0; i <= 3; ++i) {
        ((UIButton *)self.optionButtons[i]).enabled = YES;
        
        if (i == rightOption) {
            continue;
        }
        NSInteger optionID;
        do {
            optionID = section.first + arc4random() % (section.last - section.first + 1);
        } while ([usedID containsObject:@(optionID)]);
        [usedID addObject:@(optionID)];
        
        if (direction == KanaRomaji) {
            [self.optionButtons[i] setTitle:flattenedRomaji[optionID] forState:UIControlStateNormal];
        }
        else if (thisHork == Hiragana) {
            [self.optionButtons[i] setTitle:flattenedHiragana[optionID] forState:UIControlStateNormal];
        }
        else if (thisHork == Katakana) {
            [self.optionButtons[i] setTitle:flattenedKatakana[optionID] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)rangeChanged:(UIStepper *)sender
{
    [self.defaults setInteger:(NSInteger)sender.value forKey:@"KanaRange"];
    [self updateRangeLabel:sender.value];
    [self generateSequence];
    [self resetScore];
    [self next];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
    [self generateSequence];
    [self resetScore];
    [self changeMainFont];
    [self next];
}

- (void)changeMainFont
{
    NSInteger direction = [self.defaults integerForKey:@"Direction"];    
    if (direction == KanaRomaji) {
        self.mainKanaLabel.font = [UIFont fontWithName:@"Hiragino Mincho ProN" size:140.0];
        for (UIButton *optionButton in self.optionButtons) {
            optionButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20.0];
        }
    }
    else {
        self.mainKanaLabel.font = [UIFont fontWithName:@"Gill Sans" size:132.0];
        for (UIButton *optionButton in self.optionButtons) {
            optionButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:20.0];
        }
    }
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Hork"];
    [self generateSequence];
    [self resetScore];
    [self next];
}

- (void)updateRangeLabel:(NSInteger)range
{
    self.rangeLabel.text = [NSString stringWithFormat:@"あ-%@", [CMChartData hiragana][range][0]];
}

- (IBAction)optionClicked:(UIButton *)sender {
    if (self.inGuess) {
        self.totalCount += 1;
    }
    
    if (sender.currentTitle == self.rightText) {
        if (self.inGuess) {
            self.correctCount += 1;
        }
        self.inGuess = YES;
        [self next];
    }
    else {
        self.inGuess = NO;
        sender.enabled = NO;
        
        self.rightButton.titleLabel.textColor = RGBA(60, 200, 20, 1);
    }
    
    NSString *correctText = [[NSString alloc] initWithFormat:@"%d", self.correctCount];
    NSString *totalText = [[NSString alloc] initWithFormat:@"%d", self.totalCount];
    NSString *scoreText = [[NSString alloc] initWithFormat:@"%@ / %@", correctText, totalText];
    NSMutableAttributedString *scoreAttributedString = [[NSMutableAttributedString alloc] initWithString:scoreText];
    [scoreAttributedString addAttribute:NSForegroundColorAttributeName value:RGBA(103, 153, 32, 1) range:NSMakeRange(0, correctText.length)];
    self.scoreLabel.hidden = NO;
    self.scoreLabel.attributedText = scoreAttributedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
