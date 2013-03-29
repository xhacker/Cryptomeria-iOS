//
//  CMVocabularyData.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-29.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMVocabularyData.h"

@implementation CMVocabularyData

+ (NSArray *)vocabulary
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"json"];
    NSArray *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    return data;
}

@end
