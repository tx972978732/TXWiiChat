//
//  CountStringLengthHelper.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/5.
//  Copyright © 2017年 童煊. All rights reserved.
//

/* 中文字符显示占1个字符，英文字母、数字占半个字符、emoji占2～10个字符不等   */
#import "CountStringLengthHelper.h"

static NSInteger characterLength;

@implementation CountStringLengthHelper

-(instancetype)initCountHelperWithMAX_Length:(NSInteger)MAX_Length{
    self = [super init];
    if (self) {
        self.MAX_STARWORDS_LENGTH  = MAX_Length;
    }
    return self;
}

-(NSInteger)restCountLength:(NSString*)string{
    NSInteger userInfoSignatureCount = [self existedStringLength:string]/2;//当前字符长度
    NSInteger restCount = self.MAX_STARWORDS_LENGTH - userInfoSignatureCount;//剩余可输入字符长度
    if (restCount<=0) {
        restCount=0;
    }
    return restCount;
}

-(NSInteger)existedStringLength:(NSString*)string{
    characterLength = 0;
    for(int i=0; i< [string length];++i){
        int a = [string characterAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%c",a];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            if ([self stringContainsEmoji:subString]!=0){
                NSLog(@"str:%@",str);
                NSInteger emojiCount = [self stringContainsEmoji:subString];
                NSLog(@"emojiCount:%ld",(long)emojiCount);
                characterLength +=(4*emojiCount);//表情的字符长度判断
            }
            i+=1;
        }else{
            if((a >= 0x4e00 && a <= 0x9fa5)||(strlen(cString)==3)){ //判断是否为中文
                characterLength +=2;
            }else{
                characterLength +=1;
            }
        }
    }
    NSLog(@"当前字符串长度%ld",(long)characterLength/2);
    if ((characterLength%2)==0) {//输入1个英文、数字字符时立即显示占用1位（即显示剩余字数时，不足1时取整显示）
        return characterLength;
    }else{
        return characterLength+1;
    }
    //return characterLength;
}
-(NSInteger)existedStringLength1:(NSString*)string{//计算已存在的字符长度时，按实际占用长度计算
    characterLength = 0;
    for(int i=0; i< [string length];++i){
        int a = [string characterAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%c",a];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            if ([self stringContainsEmoji:subString]!=0){
                NSLog(@"str:%@",str);
                NSInteger emojiCount = [self stringContainsEmoji:subString];
                NSLog(@"emojiCount:%ld",(long)emojiCount);
                characterLength +=(4*emojiCount);//表情的字符长度判断
            }
            i+=1;
        }else{
            if((a >= 0x4e00 && a <= 0x9fa5)||(strlen(cString)==3)){ //判断是否为中文
                characterLength +=2;
            }else{
                characterLength +=1;
            }
        }
    }
    NSLog(@"当前字符串长度%ld",(long)characterLength/2);
    return characterLength;
}
-(NSInteger)judgementString:(NSString*)string{
    NSInteger count = 0;
    for (int i=0; i<string.length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            NSLog(@"subStrlength:%ld , subString:%@",(long)subString.length,subString);
            NSLog(@"strlength:%ld",(long)string.length);
            if ([self stringContainsEmoji:subString]!=0) {
                NSLog(@"judgement emoji");
                NSData *data = [subString dataUsingEncoding:NSNonLossyASCIIStringEncoding];
                NSString *goodValue = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if (goodValue.length == 6) {
                    if ((count+2)>self.MAX_STARWORDS_LENGTH*2) {
                        return i;
                    }else
                        count+=2;
                }else{
                    if ((count+2)>self.MAX_STARWORDS_LENGTH*2) {
                        return i;
                    }else
                        count+=2;
                }
                i+=1;
            }
        }else if (strlen(cString)==3){
            if ((count+2)>self.MAX_STARWORDS_LENGTH*2) {
                return i;
            }else
                count+=2;
        }else{
            if ((count+1)>self.MAX_STARWORDS_LENGTH*2) {
                return i;
            }else
                count+=1;
        }
    }
    return -1;
}
- (NSInteger)stringContainsEmoji:(NSString *)string{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block NSInteger returnValue = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue +=1;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue +=1;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue +=1;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue +=1;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue +=1;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue +=1;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue +=1;
            }
        }
    }];
    NSInteger result = returnValue;
    return result;
}
@end
