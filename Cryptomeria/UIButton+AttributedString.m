//
//  UIButton+AttributedString.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-05-11.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "UIButton+AttributedString.h"

@implementation UIButton (AttributedString)

- (void)setAttributedShadowWithColor:(UIColor *)color forState:(UIControlState)state
{
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = color;
    textShadow.shadowBlurRadius = 0.0;
    textShadow.shadowOffset = CGSizeMake(0, 1);
    NSDictionary *attributes = @{NSShadowAttributeName:textShadow};
    NSMutableAttributedString *attributedString = [self.currentAttributedTitle mutableCopy];
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    [self setAttributedTitle:attributedString forState:state];
}

@end
