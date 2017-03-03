//
//  EditUserInfoHelper.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/14.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "EditUserInfoHelper.h"
#import "WCEditUserInfoTableViewController.h"
@implementation EditUserInfoHelper
WiiSingletonClass_Implementation(EditUserInfoHelper)
-(NSString*)saveChangesWithUserInfo:(NSMutableDictionary*)userInfo editChangetype:(userInfoEditType)type{
    NSString *resultStr;
    NSString *tempResult;
    tempResult = [self saveChangesInUserWithUserInfo1:userInfo editChangeType:type];
    if ([tempResult isEqualToString:@"修改用户信息成功"]) {
        resultStr = @"修改用户信息成功";
        return resultStr;
    }
    resultStr = tempResult;//修改出现错误 返回错误信息
    return resultStr;
}
-(NSString*)saveChangesInUserWithUserInfo1:(NSMutableDictionary*)userInfo editChangeType:(userInfoEditType)type{
    User *resultUser = nil;
    AllUsers *sourceUser = nil;
    NSString *result;
    resultUser = [User getUser];//承接本地User对象
    if (resultUser.wiiError!=nil) {
        result = resultUser.wiiError;
        return result;            //获取userInfo失败 报错返回
    }
    switch (type) {
        case userInfoEditTypeName://修改用户名
            resultUser.wiiName = [userInfo valueForKey:@"wiiName"];
            sourceUser = [User synchronousDataBaseWithUser:resultUser];//将修改后的user同步至数据源
            if (sourceUser.wiiError!=nil) {
                result = @"同步至数据源出错";
                return result;//同步至数据源失败 报错返回
            }
            resultUser = [User synchronousLocalWithUser:resultUser];//将修改后的user同步至本地
            if (resultUser.wiiError!=nil) {
                result = @"同步至本地出错";//*****调整  若数据已同步至数据源，但本地保存修改失败，需重新从数据源加载用户信息或调整策略
                return result;//存储user修改信息失败 报错返回
            }
            result = @"修改用户信息成功";
            return result;
            break;
        case userInfoEditTypeSex:
            resultUser.wiiSex = [userInfo valueForKey:@"wiiSex"];
            sourceUser = [User synchronousDataBaseWithUser:resultUser];//将修改后的user同步至数据源
            if (sourceUser.wiiError!=nil) {
                result = @"同步至数据源出错";
                return result;//同步至数据源失败 报错返回
            }
            resultUser = [User synchronousLocalWithUser:resultUser];//将修改后的user同步至本地
            if (resultUser.wiiError!=nil) {
                result = @"同步至本地出错";//*****调整  若数据已同步至数据源，但本地保存修改失败，需重新从数据源加载用户信息或调整策略
                return result;//存储user修改信息失败 报错返回
            }
            result = @"修改用户信息成功";
            return result;
            break;
        case userInfoEditTypeSignature:
            resultUser.wiiSignature = [userInfo valueForKey:@"wiiSignature"];
            sourceUser = [User synchronousDataBaseWithUser:resultUser];//将修改后的user同步至数据源
            if (sourceUser.wiiError!=nil) {
                result = @"同步至数据源出错";
                return result;//同步至数据源失败 报错返回
            }
            resultUser = [User synchronousLocalWithUser:resultUser];//将修改后的user同步至本地
            if (resultUser.wiiError!=nil) {
                result = @"同步至本地出错";//*****调整  若数据已同步至数据源，但本地保存修改失败，需重新从数据源加载用户信息或调整策略
                return result;//存储user修改信息失败 报错返回
            }
            result = @"修改用户信息成功";
            return result;
            break;
        default:
            result = @"修改数据类型错误";//******增加其他数据的修改
            return result;
            break;
    }
}
-(NSString*)saveChangesInUserWithUserInfo:(NSMutableDictionary*)userInfo editChangeType:(userInfoEditType)type{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *sourceResult;
    NSString *localResult;
    NSString *result;
    resultDic = [User getUserInfo];
    if ([resultDic valueForKey:@"wiiError"]!=nil) {
        result = [resultDic valueForKey:@"wiiError"];
        return result;            //获取userInfo失败 报错返回
    }
    switch (type) {
        case userInfoEditTypeName://修改用户名
            [resultDic setValue:[userInfo valueForKey:@"wiiName"] forKey:@"wiiName"]; //修改userInfo中对应的数据(resultDic承接完成修改后的数据信息）
            sourceResult = [User synchronousDataBaseWithUser1:resultDic];//将修改后的userInfo同步至数据源
            if (![sourceResult isEqualToString:@"数据源同步成功"]) {
                result = @"同步至数据源出错";
                return result;//同步至数据源失败 报错返回
            }
            localResult = [User synchronousLocalWithUserInfo:resultDic];//将修改后的userInfo同步至本地
            if (![localResult isEqualToString:@"本地同步成功"]) {
                result = @"同步至本地出错";//*****调整  若数据已同步至数据源，但本地保存修改失败，需重新从数据源加载用户信息或调整策略
                return result;//存储user修改信息失败 报错返回
            }
            result = @"修改用户信息成功";
            return result;
            break;
        case userInfoEditTypeSex:
            [resultDic setValue:[userInfo valueForKey:@"wiiSex"] forKey:@"wiiSex"];
            sourceResult = [User synchronousDataBaseWithUser1:resultDic];
            if (![sourceResult isEqualToString:@"数据源同步成功"]) {
                result = @"同步至数据源出错";
                return result;
            }
            localResult = [User synchronousLocalWithUserInfo:resultDic];
            if (![localResult isEqualToString:@"本地同步成功"]) {
                result = @"同步至本地出错";
                return result;
            }
            result = @"修改用户信息成功";
            return result;
            break;
        case userInfoEditTypeSignature:
            [resultDic setValue:[userInfo valueForKey:@"wiiSignature"] forKey:@"wiiSignature"];
            sourceResult = [User synchronousDataBaseWithUser1:resultDic];
            if (![sourceResult isEqualToString:@"数据源同步成功"]) {
                result = @"同步至数据源出错";
                return result;
            }
            localResult = [User synchronousLocalWithUserInfo:resultDic];
            if (![localResult isEqualToString:@"本地同步成功"]) {
                result = @"同步至本地出错";
                return result;
            }
            result = @"修改用户信息成功";
            return result;
            break;
        default:
            result = @"修改数据类型错误";//******增加其他数据的修改
            return result;
            break;
    }
}
@end
