//
//  WCContactTableViewCell.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/28.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCContactTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *cellNameLabel;
@property(nonatomic,strong)UIImageView *cellImgView;

-(id)initContactCellWithStyle:(UITableViewCellStyle)style reuseIdentifyier:(NSString*)identifier;
@end
