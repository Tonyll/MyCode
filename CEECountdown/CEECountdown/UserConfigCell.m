//
//  UserConfigCell.m
//  jiemoquan
//
//  Created by zangzhenzhao on 15/5/8.
//  Copyright (c) 2015年 IvanMacAir. All rights reserved.
//

#import "UserConfigCell.h"

@implementation UserConfigCell

- (void)awakeFromNib {
    // Initialization code
    _headImage.layer.cornerRadius = 50.0f/2;
    _headImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
