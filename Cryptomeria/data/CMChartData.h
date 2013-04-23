//
//  CMChartData.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-23.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Flatten.h"

@interface CMChartData : NSObject

typedef struct _CMSection {
    NSUInteger first;
    NSUInteger last;
} CMSection;

CMSection CMMakeSection(NSUInteger first, NSUInteger last);

+ (NSArray *)romaji;
+ (NSArray *)hiragana;
+ (NSArray *)katakana;
+ (NSUInteger)lastInRow:(NSUInteger)row;
+ (CMSection)getSection:(NSUInteger)kanaId;

@end
