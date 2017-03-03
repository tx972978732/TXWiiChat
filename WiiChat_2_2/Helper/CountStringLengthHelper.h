//
//  CountStringLengthHelper.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/5.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CountStringLengthHelper : NSObject
@property(nonatomic)NSInteger MAX_STARWORDS_LENGTH;

-(instancetype)initCountHelperWithMAX_Length:(NSInteger)MAX_Length;
-(NSInteger)existedStringLength:(NSString*)string;
-(NSInteger)existedStringLength1:(NSString*)string;//计算已存在的字符长度时，按实际占用长度计算
-(NSInteger)judgementString:(NSString*)string;
- (NSInteger)stringContainsEmoji:(NSString *)string;
-(NSInteger)restCountLength:(NSString*)string;
@end
