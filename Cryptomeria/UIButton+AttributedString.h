//
//  UIButton+AttributedString.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-05-11.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AttributedString)

- (void)setAttributedShadowWithColor:(UIColor *)color forState:(UIControlState)state;
- (void)setWhiteAttributedTitle:(NSString *)title forState:(UIControlState)state;

@end
