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
#import "UIButton+AttributedString.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kNormalShadowColor RGBA(32, 85, 154, 1)
#define kRightShadowColor RGBA(122, 163, 46, 1)
#define kWrongShadowColor RGBA(153, 48, 32, 1)
#define kScoreRightColor RGBA(103, 153, 32, 1)

#define kNormalButtonImage @"option-normal"
#define kNormalPressingButtonImage @"option-normal-pressing"
#define kWrongButtonImage @"option-wrong"
#define kWrongPressingButtonImage @"option-wrong-pressing"
#define kRightButtonImage @"option-right"
#define kRightPressingButtonImage @"option-right-pressing"

#define kKanaSansBoldFont @"HiraKakuProN-W6"

NSString * const kKanaRangeKey = @"KanaRange";
NSInteger const kRangeMax = 25;

@interface CMTestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *horkControl;
@property (weak, nonatomic) IBOutlet UIButton *rangeDecreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeIncreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *mainRomajiLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainKanaLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak) UILabel *mainLabel;
@property NSUserDefaults *defaults;
@property NSMutableArray *sequence;
@property NSInteger prevHork;
@property NSString *rightText;
@property UIButton *rightButton;
@property NSInteger correctCount;
@property NSInteger totalCount;
@property BOOL inGuess;

@property NSMutableParagraphStyle *noSpacingParagraphStyle;

#define NO_LINE_SPACING(s) [[NSAttributedString alloc] initWithString:s attributes:@{NSParagraphStyleAttributeName:self.noSpacingParagraphStyle}]

- (void)updateRangeLabel;
- (void)generateSequence;
- (void)resetScore;
- (void)next;
- (void)changeFont;

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
    
    self.noSpacingParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    self.noSpacingParagraphStyle.lineSpacing = 0.0;
    
    [self updateRangeLabel];
    NSInteger direction = [self.defaults integerForKey:@"Direction"];
    [self.directionControl setSelectedSegmentIndex:direction];
    NSInteger hork = [self.defaults integerForKey:@"Hork"];
    [self.horkControl setSelectedSegmentIndex:hork];
    
    // control style
    UIImage *segmentBackground = [[UIImage imageNamed:@"segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *segmentBackgroundSelected = [[UIImage imageNamed:@"segment-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UISegmentedControl appearance] setBackgroundImage:segmentBackground
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentBackgroundSelected
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"segment-divider-00"]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"segment-divider-01"]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"segment-divider-10"]
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                        UITextAttributeFont:[UIFont fontWithName:kKanaSansBoldFont size:13.0],
                                   UITextAttributeTextColor:RGBA(102, 102, 102, 1),
                             UITextAttributeTextShadowColor:RGBA(255, 255, 255, 0.8),
                            UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)]}
                                                   forState:UIControlStateNormal];
    
    CGFloat const yOffset = 4.0;
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:0];
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:1];
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:2];
    [self.directionControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:0];
    [self.directionControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:1];
    self.rangeLabelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.prevHork = Katakana;
    [self generateSequence];
    [self resetScore];
    [self changeFont];
    self.inGuess = YES;
    [self next];
}

- (void)generateSequence
{
    self.sequence = [[NSMutableArray alloc] init];
    NSUInteger kanaRange = [self.defaults integerForKey:kKanaRangeKey];
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
    NSInteger kanaRange = [self.defaults integerForKey:kKanaRangeKey];
    
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
    NSString *mainText;
    if (direction == RomajiKana) {
        mainText = flattenedRomaji[thisID];
    }
    else if (thisHork == Hiragana) {
        mainText = flattenedHiragana[thisID];
    }
    else if (thisHork == Katakana) {
        mainText = flattenedKatakana[thisID];
    }
    self.mainLabel.text = mainText;
    
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
    [self.optionButtons[rightOption] setAttributedTitle:NO_LINE_SPACING(self.rightText) forState:UIControlStateNormal];
    self.rightButton = self.optionButtons[rightOption];
    NSMutableArray *usedID = [[NSMutableArray alloc] initWithObjects:@(thisID), nil];
    
    for (NSInteger i = 0; i <= 3; ++i) {
        if (i == rightOption) {
            continue;
        }
        NSInteger optionID;
        do {
            optionID = section.first + arc4random() % (section.last - section.first + 1);
        } while ([usedID containsObject:@(optionID)]);
        [usedID addObject:@(optionID)];
        
        NSString *thisText;
        if (direction == KanaRomaji) {
            thisText = flattenedRomaji[optionID];
        }
        else if (thisHork == Hiragana) {
            thisText = flattenedHiragana[optionID];
        }
        else if (thisHork == Katakana) {
            thisText = flattenedKatakana[optionID];
        }
        [self.optionButtons[i] setAttributedTitle:NO_LINE_SPACING(thisText) forState:UIControlStateNormal];
    }

    // refresh buttons
    for (UIButton *button in self.optionButtons) {
        [button setBackgroundImage:[UIImage imageNamed:kNormalButtonImage] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:kNormalPressingButtonImage] forState:UIControlStateHighlighted];
        [button setAttributedShadowWithColor:kNormalShadowColor forState:UIControlStateNormal];
    }
}

- (IBAction)rangeDecreased:(UIButton *)sender {
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    if (range > 0) {
        range -= 1;
        if (range == 0) {
            self.rangeDecreaseButton.enabled = NO;
        }
        self.rangeIncreaseButton.enabled = YES;
    }
    [self.defaults setInteger:range forKey:kKanaRangeKey];
    [self rangeChanged];
}

- (IBAction)rangeIncreased:(UIButton *)sender {
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    if (range < kRangeMax) {
        range += 1;
        if (range == kRangeMax) {
            self.rangeIncreaseButton.enabled = NO;
        }
        self.rangeDecreaseButton.enabled = YES;
    }
    [self.defaults setInteger:range forKey:kKanaRangeKey];
    [self rangeChanged];
}

- (void)rangeChanged
{
    [self updateRangeLabel];
    [self generateSequence];
    [self resetScore];
    [self next];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:@"Direction"];
    [self generateSequence];
    [self resetScore];
    [self changeFont];
    [self next];
}

- (void)changeFont
{
    NSInteger direction = [self.defaults integerForKey:@"Direction"];    
    if (direction == KanaRomaji) {
        self.mainRomajiLabel.hidden = YES;
        self.mainKanaLabel.hidden = NO;
        self.mainLabel = self.mainKanaLabel;
        for (UIButton *optionButton in self.optionButtons) {
            optionButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20.0];
        }
    }
    else {
        self.mainKanaLabel.hidden = YES;
        self.mainRomajiLabel.hidden = NO;
        self.mainLabel = self.mainRomajiLabel;
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

- (void)updateRangeLabel
{
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    self.rangeLabelButton.titleLabel.text = [NSString stringWithFormat:@"あ-%@", [CMChartData hiragana][range][0]];
}

- (IBAction)optionClicked:(UIButton *)sender {
    if (self.inGuess) {
        self.totalCount += 1;
    }
    
    if ([sender.currentAttributedTitle.string isEqualToString:self.rightText]) {
        if (self.inGuess) {
            self.correctCount += 1;
        }
        self.inGuess = YES;
        [self next];
    }
    else {
        self.inGuess = NO;
        [sender setBackgroundImage:[UIImage imageNamed:kWrongButtonImage] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:kWrongPressingButtonImage] forState:UIControlStateHighlighted];
        [sender setAttributedShadowWithColor:kWrongShadowColor forState:UIControlStateNormal];
        
        [self.rightButton setBackgroundImage:[UIImage imageNamed:kRightButtonImage] forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:kRightPressingButtonImage] forState:UIControlStateHighlighted];
        [self.rightButton setAttributedShadowWithColor:kRightShadowColor forState:UIControlStateNormal];
    }
    
    NSString *correctText = [[NSString alloc] initWithFormat:@"%d", self.correctCount];
    NSString *totalText = [[NSString alloc] initWithFormat:@"%d", self.totalCount];
    NSString *scoreText = [[NSString alloc] initWithFormat:@"%@ / %@", correctText, totalText];
    NSMutableAttributedString *scoreAttributedString = [[NSMutableAttributedString alloc] initWithString:scoreText];
    [scoreAttributedString addAttribute:NSForegroundColorAttributeName value:kScoreRightColor range:NSMakeRange(0, correctText.length)];
    self.scoreLabel.hidden = NO;
    self.scoreLabel.attributedText = scoreAttributedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
