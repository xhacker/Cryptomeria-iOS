//
//  CMVocabularyCell.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-29.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMVocabularyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kanaLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UILabel *romajiLabel;

@end
