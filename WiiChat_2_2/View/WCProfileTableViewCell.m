//
//  WCProfileTableViewCell.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/9.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCProfileTableViewCell.h"

@implementation WCProfileTableViewCell
-(instancetype)initHeadCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 22, 200, 28)];
        _cellNameLabel.font = [UIFont systemFontOfSize:24.0f];
        _cellImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 64, 64)];
        _cellImgView.layer.masksToBounds = YES;
        _cellImgView.layer.cornerRadius = 8.0f;
        _cellDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 56, 200, 15)];
        _cellDetailLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_cellNameLabel];
        [self.contentView addSubview:_cellImgView];
        [self.contentView addSubview:_cellDetailLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   return self;
}
-(instancetype)initOtherCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 150, 15)];
        self.cellImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 30, 32)];
        self.cellDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(242, 12, 100, 15)];
        self.cellDetailLabel.font = [UIFont systemFontOfSize:14.0];
        self.cellDetailLabel.textColor = [UIColor lightGrayColor];
        self.cellDetailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.cellNameLabel];
        [self.contentView addSubview:self.cellImgView];
        [self.contentView addSubview:self.cellDetailLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(instancetype)initUserInfoHeadCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, 100, 15)];
        self.cellImgView = [[UIImageView alloc]initWithFrame:CGRectMake(278, 12, 69, 69)];
        self.cellImgView.layer.masksToBounds = YES;
        self.cellImgView.layer.cornerRadius = 8.0f;
        [self.contentView addSubview:self.cellNameLabel];
        [self.contentView addSubview:self.cellImgView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(instancetype)initUserInfoOtherCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 15)];
        self.cellDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 12, 220, 15)];
        self.cellDetailLabel.font = [UIFont systemFontOfSize:14.0];
        self.cellDetailLabel.textColor = [UIColor lightGrayColor];
        self.cellDetailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.cellNameLabel];
        [self.contentView addSubview:self.cellDetailLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(instancetype)initEditUserInfoTypeNameWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 0, 364, 40)];
//        self.cellTextField.backgroundColor = [UIColor clearColor];
//        //self.cellTextField.borderStyle = UITextBorderStyleRoundedRect;
//        self.cellTextField.font = [UIFont fontWithName:@"Arial" size:14.0f];
//        self.cellTextField.textAlignment = NSTextAlignmentLeft;
//        self.cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//         [self.contentView addSubview:self.cellTextField];

        self.cellTextView = [[UITextView alloc]initWithFrame:CGRectMake(8, 0, 364, 40)];
        self.cellTextView.editable = YES;
        self.cellTextView.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.cellTextView.textAlignment = NSTextAlignmentLeft;
        self.cellTextView.scrollEnabled = NO;
        [self.contentView addSubview:self.cellTextView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
-(instancetype)initEditUserInfoTypeNameFieldWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                self.cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 0, 364, 40)];
                self.cellTextField.backgroundColor = [UIColor clearColor];
                //self.cellTextField.borderStyle = UITextBorderStyleRoundedRect;
                self.cellTextField.returnKeyType = UIReturnKeyDone;
                self.cellTextField.font = [UIFont fontWithName:@"Arial" size:14.0f];
                self.cellTextField.textAlignment = NSTextAlignmentLeft;
                self.cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                 [self.contentView addSubview:self.cellTextField];}
                self.selectionStyle = UITableViewCellSelectionStyleNone;
        return self;
}
-(instancetype)initEditUserInfoTypeGenderWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 100, 15)];
        [self.contentView addSubview:self.cellNameLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(instancetype)initEditUserInfoTypeSignatureWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellTextView = [[UITextView alloc]initWithFrame:CGRectMake(8, 0, 364, 80)];
        self.cellTextView.editable = YES;
        self.cellTextView.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.cellTextView.textAlignment = NSTextAlignmentLeft;
        self.cellTextView.scrollEnabled = NO;
        self.cellDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(350, 70, 24, 24)];
        self.cellDetailLabel.font = [UIFont systemFontOfSize:14.0];
        self.cellDetailLabel.textColor = [UIColor lightGrayColor];
        self.cellDetailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cellTextView];
        [self.contentView addSubview:self.cellDetailLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(instancetype)initEditUserInfoTypeHeadImgWithStyle:(UITableViewCellStyle)style reuserIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 803)];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.backgroundView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
