//
//  WCHeadImgScrollVIew.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/6.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HeadImgScrollViewType){
    headImgScrollViewTypeDefault = 0,
    headImgScrollViewTypeReserve
};

@interface WCHeadImgScrollVIew : UIScrollView
@property(nonatomic,strong)UIImageView *headImgView;

- (instancetype)initHeadImgScrollViewWithFrame:(CGRect)frame ViewType:(HeadImgScrollViewType)ViewType headImg:(UIImage*)headImg;
@end
