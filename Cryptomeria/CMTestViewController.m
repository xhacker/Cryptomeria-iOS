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
#import "UIImage+Device.h"
#import "iOSVersion.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kNormalShadowColor RGBA(32, 85, 154, 1)
#define kRightShadowColor RGBA(122, 163, 46, 1)
#define kWrongShadowColor RGBA(153, 48, 32, 1)
#define kScoreRightColor RGBA(103, 153, 32, 1)

static NSString * const kNormalButtonImage = @"option-normal";
static NSString * const kNormalPressingButtonImage = @"option-normal-pressing";
static NSString * const kWrongButtonImage = @"option-wrong";
static NSString * const kWrongPressingButtonImage = @"option-wrong-pressing";
static NSString * const kRightButtonImage = @"option-right";
static NSString * const kRightPressingButtonImage = @"option-right-pressing";

static NSString * const kAvenirFont = @"AvenirNext-Medium";
static NSString * const kAvenirBoldFont = @"AvenirNext-Bold";
static NSString * const kHiraKakuFont = @"HiraKakuProN-W3";
static NSString * const kHiraKakuBoldFont = @"HiraKakuProN-W6";

static NSString * const kKanaRangeKey = @"KanaRange";
static NSString * const kDirectionKey = @"Direction";
static NSString * const kHorkKey = @"Hork";
static NSInteger  const kRangeMax = 25;

@interface CMTestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *horkControl;
@property (weak, nonatomic) IBOutlet UIButton *rangeDecreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeIncreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *mainKanaLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainKanaLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *mainRomajiLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) UILabel *mainLabel;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableArray *sequence;
@property (nonatomic) NSInteger prevHork;
@property (strong, nonatomic) NSString *rightText;
@property (strong, nonatomic) UIButton *rightButton;
@property (nonatomic) NSInteger correctCount;
@property (nonatomic) NSInteger totalCount;
@property (strong, nonatomic) NSArray *flattenedRomaji;
@property (strong, nonatomic) NSArray *flattenedHiragana;
@property (strong, nonatomic) NSArray *flattenedKatakana;
@property (nonatomic) BOOL inGuess;

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
    
    [self updateRangeLabelAndButton];
    NSInteger direction = [self.defaults integerForKey:kDirectionKey];
    [self.directionControl setSelectedSegmentIndex:direction];
    NSInteger hork = [self.defaults integerForKey:kHorkKey];
    [self.horkControl setSelectedSegmentIndex:hork];
    
    self.flattenedRomaji = [[CMChartData romaji] flatten];
    self.flattenedHiragana = [[CMChartData hiragana] flatten];
    self.flattenedKatakana = [[CMChartData katakana] flatten];
    
    [self configurePosition];
    [self configureStyle];
    
    self.prevHork = Katakana;
    [self generateSequence];
    [self resetScore];
    [self changeFont];
    self.inGuess = YES;
    [self next];
}

- (void)configurePosition
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        // 肾5！壕！
        CGFloat offset = (568 - 480) / 2;
        self.mainKanaLabelTopConstraint.constant += offset;
    }
}

- (void)configureStyle
{
    CGFloat edgeInset = IS_IPAD() ? 7.0 : 5.0;
    UIImage *segmentBackground = [[UIImage imageNamedForCurrentDevice:@"segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, edgeInset, 0, edgeInset)];
    UIImage *segmentBackgroundSelected = [[UIImage imageNamedForCurrentDevice:@"segment-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, edgeInset, 0, edgeInset)];
    [[UISegmentedControl appearance] setBackgroundImage:segmentBackground
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentBackgroundSelected
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamedForCurrentDevice:@"segment-divider-00"]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamedForCurrentDevice:@"segment-divider-01"]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamedForCurrentDevice:@"segment-divider-10"]
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    CGFloat fontSize = IS_IPAD() ? 19.0 : 13.0;
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                        UITextAttributeFont:[UIFont fontWithName:kHiraKakuBoldFont size:fontSize],
                                   UITextAttributeTextColor:RGBA(140, 140, 140, 1),
                             UITextAttributeTextShadowColor:RGBA(255, 255, 255, 0.8),
                            UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)]}
                                                   forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                   UITextAttributeTextColor:RGBA(102, 102, 102, 1)}
                                                   forState:UIControlStateSelected];
    
    // adjust baseline
    CGFloat yOffset = 0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        yOffset = IS_IPAD() ? 6.0 : 5.0;
    }
    else {
        yOffset = IS_IPAD() ? 2.0 : 1.5;
    }
    
    self.rangeLabelButton.contentEdgeInsets = UIEdgeInsetsMake(yOffset * 2, 0, 0, 0);
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:0];
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:1];
    [self.horkControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:2];
    [self.directionControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:0];
    [self.directionControl setContentOffset:CGSizeMake(0, yOffset) forSegmentAtIndex:1];
    
#warning remember auto shrink of main label
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
    NSInteger hork = [self.defaults integerForKey:kHorkKey];
    NSInteger direction = [self.defaults integerForKey:kDirectionKey];
    NSInteger kanaRange = [self.defaults integerForKey:kKanaRangeKey];
    
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
        mainText = self.flattenedRomaji[thisID];
    }
    else if (thisHork == Hiragana) {
        mainText = self.flattenedHiragana[thisID];
    }
    else if (thisHork == Katakana) {
        mainText = self.flattenedKatakana[thisID];
    }
    self.mainLabel.attributedText = [[NSAttributedString alloc] initWithString:mainText];
    
    CMSection section = [CMChartData getSection:thisID];
    NSUInteger lastInRange = [CMChartData lastInRow:kanaRange];
    if (section.last > lastInRange) {
        section.last = lastInRange;
    }
 
    NSInteger rightOption = arc4random() % 4;
    if (direction == KanaRomaji) {
        self.rightText = self.flattenedRomaji[thisID];
    }
    else if (thisHork == Hiragana) {
        self.rightText = self.flattenedHiragana[thisID];
    }
    else if (thisHork == Katakana) {
        self.rightText = self.flattenedKatakana[thisID];
    }
    [self.optionButtons[rightOption] setWhiteAttributedTitle:self.rightText forState:UIControlStateNormal];
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
            thisText = self.flattenedRomaji[optionID];
        }
        else if (thisHork == Hiragana) {
            thisText = self.flattenedHiragana[optionID];
        }
        else if (thisHork == Katakana) {
            thisText = self.flattenedKatakana[optionID];
        }
        [self.optionButtons[i] setWhiteAttributedTitle:thisText forState:UIControlStateNormal];
    }

    // refresh buttons
    for (UIButton *button in self.optionButtons) {
        [button setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kNormalButtonImage]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kNormalPressingButtonImage]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                          forState:UIControlStateHighlighted];
        [button setAttributedShadowWithColor:kNormalShadowColor forState:UIControlStateNormal];
    }
}

- (IBAction)rangeDecreased:(UIButton *)sender {
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    if (range > 0) {
        range -= 1;
    }
    [self.defaults setInteger:range forKey:kKanaRangeKey];
    [self rangeChanged];
}

- (IBAction)rangeIncreased:(UIButton *)sender {
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    if (range < kRangeMax) {
        range += 1;
    }
    [self.defaults setInteger:range forKey:kKanaRangeKey];
    [self rangeChanged];
}

- (void)rangeChanged
{
    [self updateRangeLabelAndButton];
    [self generateSequence];
    [self resetScore];
    [self next];
}

- (void)updateRangeLabelAndButton
{
    NSInteger range = [self.defaults integerForKey:kKanaRangeKey];
    
    if (range <= 0) {
        self.rangeDecreaseButton.enabled = NO;
    }
    else {
        self.rangeDecreaseButton.enabled = YES;
    }
    if (range >= kRangeMax) {
        self.rangeIncreaseButton.enabled = NO;
    }
    else {
        self.rangeIncreaseButton.enabled = YES;
    }
    
    NSString *rangeText = [NSString stringWithFormat:@"あ-%@", [CMChartData hiragana][range][0]];
    [self.rangeLabelButton setTitle:rangeText forState:UIControlStateNormal];
}

- (IBAction)directionChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:kDirectionKey];
    [self generateSequence];
    [self resetScore];
    [self changeFont];
    [self next];
}

- (void)changeFont
{
    NSInteger direction = [self.defaults integerForKey:kDirectionKey];
    CGFloat fontSize = IS_IPAD() ? 30.0 : 20.0;
    if (direction == KanaRomaji) {
        self.mainRomajiLabel.hidden = YES;
        self.mainKanaLabel.hidden = NO;
        self.mainLabel = self.mainKanaLabel;
        for (UIButton *optionButton in self.optionButtons) {
            optionButton.titleLabel.font = [UIFont fontWithName:kAvenirFont size:fontSize];
        }
    }
    else {
        self.mainKanaLabel.hidden = YES;
        self.mainRomajiLabel.hidden = NO;
        self.mainLabel = self.mainRomajiLabel;
        for (UIButton *optionButton in self.optionButtons) {
            optionButton.titleLabel.font = [UIFont fontWithName:kHiraKakuFont size:fontSize];
        }
    }
}

- (IBAction)horkChanged:(UISegmentedControl *)sender
{
    [self.defaults setInteger:sender.selectedSegmentIndex forKey:kHorkKey];
    [self generateSequence];
    [self resetScore];
    [self next];
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
        [sender setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kWrongButtonImage]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                          forState:UIControlStateNormal];
        [sender setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kWrongPressingButtonImage]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                          forState:UIControlStateHighlighted];
        [sender setAttributedShadowWithColor:kWrongShadowColor forState:UIControlStateNormal];
        
        [self.rightButton setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kRightButtonImage]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                                    forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[[UIImage imageNamedForCurrentDevice:kRightPressingButtonImage]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                                    forState:UIControlStateHighlighted];
        [self.rightButton setAttributedShadowWithColor:kRightShadowColor forState:UIControlStateNormal];
    }
    
    NSString *correctText = [[NSString alloc] initWithFormat:@"%d", self.correctCount];
    NSString *totalText = [[NSString alloc] initWithFormat:@"%d", self.totalCount];
    NSString *scoreText = [[NSString alloc] initWithFormat:@"%@ / %@", correctText, totalText];
    NSMutableAttributedString *scoreAttributedString = [[NSMutableAttributedString alloc] initWithString:scoreText];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: kScoreRightColor,
                                 NSFontAttributeName: [UIFont fontWithName:kAvenirBoldFont size:self.scoreLabel.font.pointSize]};
    [scoreAttributedString addAttributes:attributes range:NSMakeRange(0, correctText.length)];
    self.scoreLabel.hidden = NO;
    self.scoreLabel.attributedText = scoreAttributedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
