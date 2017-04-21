//
//  WCAnimationView.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/4/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCAnimationView : UIView

@property(nonatomic,assign,readonly)BOOL isShowingAnimation;
@property(nonatomic,assign)BOOL animationStart;
@property(nonatomic,assign)CGFloat  animationAlfha;

- (void)setAnimationStart:(BOOL)animationStart;
- (void)setAnimationAlfha:(CGFloat)animationAlfha;
@end
