//
//  CMChartData.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-23.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "CMChartData.h"

@implementation CMChartData

+ (NSArray *)romaji
{
    NSArray *rs = @[
        @[@"a",   @"i",   @"u",   @"e",   @"o"],
        @[@"ka",  @"ki",  @"ku",  @"ke",  @"ko"],
        @[@"sa",  @"shi", @"su",  @"se",  @"so"],
        @[@"ta",  @"chi", @"tsu", @"te",  @"to"],
        @[@"na",  @"ni",  @"nu",  @"ne",  @"no"],
        @[@"ha",  @"hi",  @"fu",  @"he",  @"ho"],
        @[@"ma",  @"mi",  @"mu",  @"me",  @"mo"],
        @[@"ya",  @"(i)", @"yu",  @"(e)", @"yo"],
        @[@"ra",  @"ri",  @"ru",  @"re",  @"ro"],
        @[@"wa",  @"(i)", @"(u)", @"(e)", @"wo"],
        @[@"n/m", @"",    @"",    @"",    @""],
        @[@"ga",  @"gi",  @"gu",  @"ge",  @"go"],
        @[@"za",  @"ji",  @"zu",  @"ze",  @"zo"],
        @[@"da",  @"ji",  @"zu",  @"de",  @"do"],
        @[@"ba",  @"bi",  @"bu",  @"be",  @"bo"],
        @[@"pa",  @"pi",  @"pu",  @"pe",  @"po"],
        @[@"kya", @"kyu", @"kyo", @"",    @""],
        @[@"gya", @"gyu", @"gyo", @"",    @""],
        @[@"sha", @"shu", @"sho", @"",    @""],
        @[@"ja",  @"ju",  @"jo",  @"",    @""],
        @[@"cha", @"chu", @"cho", @"",    @""],
        @[@"nya", @"nyu", @"nyo", @"",    @""],
        @[@"hya", @"hyu", @"hyo", @"",    @""],
        @[@"bya", @"byu", @"byo", @"",    @""],
        @[@"pya", @"pyu", @"pyo", @"",    @""],
        @[@"mya", @"myu", @"myo", @"",    @""],
        ];
    return rs;
}

@end
