//
//  NSArray+Flatten.m
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-28.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "NSArray+Flatten.h"

@implementation NSArray (Flatten)

- (NSArray *)flatten
{
    NSMutableArray *flattened = [[NSMutableArray alloc] init];
    for (NSArray *row in self)
    {
        for (NSString *item in row) {
            if (item.length > 0 && ![item hasPrefix:@"("]) {
                [flattened addObject:item];
            }
        }
    }
    
    return flattened;
}

@end
