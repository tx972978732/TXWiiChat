//
//  WCScanBGView.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/21.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCScanBGView.h"

@implementation WCScanBGView

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    super.backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setScanRect:(CGRect)scanRect{
    _scanRect = scanRect;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, rect);
    
    [self.backgroundColor setFill];
    CGRect topRect = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetMinY(_scanRect));
    CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(_scanRect), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(_scanRect));
    CGRect leftRect = CGRectMake(0, CGRectGetMinY(_scanRect), CGRectGetMinX(_scanRect), CGRectGetHeight(_scanRect));
    CGRect rightRect = CGRectMake(CGRectGetMaxX(_scanRect), CGRectGetMinY(_scanRect), CGRectGetWidth(bounds) - CGRectGetMaxX(_scanRect), CGRectGetHeight(_scanRect));
    
    CGContextAddRect(context, topRect);
    CGContextAddRect(context, bottomRect);
    CGContextAddRect(context, leftRect);
    CGContextAddRect(context, rightRect);
    
    CGContextFillPath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
