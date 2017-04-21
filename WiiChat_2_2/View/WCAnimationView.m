//
//  WCAnimationView.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/4/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCAnimationView.h"

@interface WCAnimationView ()
@property(nonatomic,assign,readwrite)BOOL isShowingAnimation;
@property(nonatomic,strong)CAEmitterLayer *emitterLayer;
@property(nonatomic,strong)CAEmitterCell *emitterCell;

@end

@implementation WCAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicValueInit];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)basicValueInit{
    _isShowingAnimation = NO;
    _animationAlfha = 0;
    _animationStart = NO;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_emitterLayer&&_emitterCell) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
        _emitterCell = nil;
    }
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.bounds = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:_emitterLayer];
    _emitterLayer.birthRate = 100;
    _emitterLayer.lifetime = 4;
    _emitterLayer.velocity = 100;
    _emitterLayer.scale = 0.5;
    //_emitterLayer.spin = M_PI;
    _emitterLayer.renderMode = kCAEmitterLayerBackToFront;
    _emitterLayer.emitterPosition = self.center;
    _emitterLayer.emitterSize = self.bounds.size;
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
    _emitterLayer.emitterMode = kCAEmitterLayerLine;
    
    _emitterCell = [CAEmitterCell emitterCell];
    //_emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"MoreEmotions"].CGImage);
    _emitterCell.contents = (__bridge id _Nullable)([self creratCircle].CGImage);
    _emitterCell.birthRate = 1.f;
    _emitterCell.lifetime = 1.f;
    _emitterCell.velocity = 1.f;
    _emitterCell.velocityRange = 40.f;
    _emitterCell.yAcceleration = 10.f;
    _emitterCell.emissionLongitude = M_PI;
    _emitterCell.emissionRange = M_PI_4;
    _emitterCell.scale = 1;
    _emitterCell.scaleRange = 0.5;
    _emitterCell.scaleSpeed = 0.05;
    _emitterCell.color = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:1.f].CGColor;
    _emitterCell.redRange = 1.f;
    _emitterCell.greenRange = 1.f;
    _emitterCell.blueRange = 1.f;
//    _emitterCell.redSpeed = .01f;
//    _emitterCell.greenSpeed = .01f;
//    _emitterCell.blueSpeed = .01f;
    _emitterCell.alphaRange = .8f;
    _emitterCell.alphaSpeed = -.1f;
    
    
    _emitterLayer.emitterCells = @[_emitterCell];
    
}

- (UIImage*)creratCircle{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 30, 30)].CGPath;
    circleLayer.bounds = CGRectMake(0, 0, 30, 30);
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    circleLayer.position = circleView.center;
    [circleView.layer addSublayer:circleLayer];
    
    CGSize s = circleView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [circleView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)convertViewToImage:(UIView*)v{
        CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
        [v.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}

- (void)setAnimationStart:(BOOL)animationStart{
    if (_isShowingAnimation) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
        _emitterCell = nil;
        _isShowingAnimation = NO;
    }
    _animationStart = animationStart;
    _isShowingAnimation = animationStart;
    [self setNeedsDisplay];
}
- (void)setAnimationAlfha:(CGFloat)animationAlfha{
    
}


@end
