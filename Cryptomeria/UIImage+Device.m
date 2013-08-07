//
//  UIImage+Device.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-07-21.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "UIImage+Device.h"

@implementation UIImage (Device)

+ (UIImage *)imageNamedForCurrentDevice:(NSString *)name
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        name = [@"ipad-" stringByAppendingString:name];
    }
    return [UIImage imageNamed:name];
}

@end
