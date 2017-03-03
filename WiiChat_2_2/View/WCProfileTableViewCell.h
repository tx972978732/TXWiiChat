//
//  WCProfileTableViewCell.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/9.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCProfileTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *cellNameLabel;
@property(nonatomic,strong)UIImageView *cellImgView;
@property(nonatomic,strong)UILabel *cellDetailLabel;
@property(nonatomic,strong)UITextField *cellTextField;
@property(nonatomic,strong)UITextView *cellTextView;
@property(nonatomic,strong)UIView *cellBackgroundView;
-(instancetype)initHeadCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initOtherCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initUserInfoHeadCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initUserInfoOtherCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initEditUserInfoTypeNameWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initEditUserInfoTypeNameFieldWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initEditUserInfoTypeGenderWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initEditUserInfoTypeSignatureWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
-(instancetype)initEditUserInfoTypeHeadImgWithStyle:(UITableViewCellStyle)style reuserIdentifier:(NSString*)reuseIdentifier;
@end
