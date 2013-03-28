//
//  NSArray+Flatten.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-28.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Flatten)

/** Convert the kana array to 1-dimension, and remove useless objects.
 */
- (NSArray *)flatten;

@end
