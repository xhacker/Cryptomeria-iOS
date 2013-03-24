//
//  CMChartCell.h
//  Cryptomeria
//
//  Created by Xhacker on 2013-03-23.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMChartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kanaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *romajiTitleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *kanaLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *romajiLabels;

@end
