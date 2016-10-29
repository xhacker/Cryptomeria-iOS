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
    NSInteger first;
    NSInteger last;
} CMSection;

CMSection CMMakeSection(NSInteger first, NSInteger last);

+ (NSArray<NSArray *> *)romaji;
+ (NSArray<NSArray *> *)hiragana;
+ (NSArray<NSArray *> *)katakana;
+ (NSInteger)lastInRow:(NSInteger)row;
+ (CMSection)getSection:(NSInteger)kanaId;

@end
