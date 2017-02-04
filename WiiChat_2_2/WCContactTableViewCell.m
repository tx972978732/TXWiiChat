//
//  WCContactTableViewCell.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/28.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCContactTableViewCell.h"

@implementation WCContactTableViewCell

-(id)initContactCellWithStyle:(UITableViewCellStyle)style reuseIdentifyier:(NSString*)identifier{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 26, 100, 22)];
        self.cellNameLabel.textColor = [UIColor darkTextColor];
        self.cellNameLabel.font = [UIFont fontWithName:@"Arial" size:15];
        self.cellImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 64, 64)];
        self.cellImgView.layer.masksToBounds = YES;
        self.cellImgView.layer.cornerRadius = 8.0f;
        [self.contentView addSubview:self.cellNameLabel];
        [self.contentView addSubview:self.cellImgView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
