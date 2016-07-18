//
//  UserInfoTableViewCell.m
//  CEECountdown
//
//  Created by Tony L on 7/15/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).mas_offset(@10);
            make.width.mas_equalTo(@80);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentLabel setTextColor:[UIColor grayColor]];
        [self.contentLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).mas_offset(@-35);
            make.width.mas_equalTo(@200);
        }];
        
        self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_image"]];
        [self.contentView addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).mas_offset(@-15);
            make.width.mas_equalTo(@5);
            make.height.mas_equalTo(@10);
        }];
    }
    
    return self;
}

@end
