//
//  WCHeadImgScrollVIew.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/6.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCHeadImgScrollVIew.h"

@implementation WCHeadImgScrollVIew

- (instancetype)initHeadImgScrollViewWithFrame:(CGRect)frame ViewType:(HeadImgScrollViewType)ViewType headImg:(UIImage*)headImg{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 2;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        self.scrollEnabled = NO;
        self.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
        self.headImgView.image = headImg;
        [self addSubview:self.headImgView];
    }
    return self;
}

- (UIImageView*)headImgView{
    if (_headImgView) {
        return _headImgView;
    }
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.bounds.size.height-400)];
    _headImgView.userInteractionEnabled = YES;
    _headImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    dispatch_block_t animations = ^{
        _headImgView.transform = CGAffineTransformIdentity;//给图片增加水平翻转动画
    };
    [UIView animateWithDuration:3.3 delay:0. usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];

    return _headImgView;
    
}


@end
