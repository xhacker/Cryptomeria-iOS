//
//  NSMutableArray+Shuffling.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-26.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Shuffling)

/** This category enhances NSMutableArray by providing methods to randomly
 * shuffle the elements using the Fisher-Yates algorithm.
 */
- (void)shuffle;

@end
