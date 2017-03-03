//
//  AddContactHelper.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "AddContactHelper.h"
#import "ErrorInfo.h"

@implementation AddContactHelper
WiiSingletonClass_Implementation(AddContactHelper)
-(id)searchSourceDataSourceWithInfo:(NSMutableDictionary*)info{
    NSString *checkResult;
    AllUsers *resultUser = [AllUsers getUserFromDataSourceWithInfo1:info];
    NSLog(@"搜索结果:%@",resultUser);
    if (resultUser.wiiError!=nil) {
        if ([resultUser.wiiError isEqualToString:Error_002]) {
            checkResult = @"noSuchUserInDataBase";
        }else{
            checkResult = @"failToCheckUserInfo";
        }
        return checkResult;
    }else if ([resultUser.wiiID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]]){
        checkResult = @"isLocalUser";
        return checkResult;
    }else{
        return resultUser;
    }
}
-(BOOL)isFriendContact:(AllUsers*)userInfo{
    User *localUser = [User getUser];
    for (Contact *tempContact in localUser.contact) {
        if ([userInfo.wiiID isEqualToString:tempContact.wiiID]) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)synchronizeContactInfo:(AllUsers*)contact toUser:(User*)user{
    NSString *result;
    //获取数据源中本地帐号的信息
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfoDic setValue:user.wiiID forKey:@"wiiID"];
    AllUsers *tempAllusers = [AllUsers getUserFromDataSourceWithInfo1:userInfoDic];
    if (tempAllusers.wiiError!=nil) {
        result = tempAllusers.wiiError;
        return result;
    }
    //替换数据源中对应本地帐号的contact数据
    if (tempAllusers.wiiContact!=nil) {
        NSLog(@"tempAllusers.wiiContact before synchronize = %@",tempAllusers.wiiContact);
        NSMutableDictionary *tempUserContactDic = tempAllusers.wiiContact;
        [tempUserContactDic setValue:contact.wiiID forKey:[NSString stringWithFormat:@"wiiID=%@",contact.wiiID]];
        NSLog(@"tempAllusers.wiiContact = %@",tempAllusers.wiiContact);
        NSLog(@"tmepUserContactDic = %@",tempUserContactDic);
        tempAllusers.wiiContact = tempUserContactDic;
    }else{
        NSMutableDictionary *tempUserContactDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempUserContactDic setValue:contact.wiiID forKey:[NSString stringWithFormat:@"wiiID=%@",contact.wiiID]];
        tempAllusers.wiiContact = tempUserContactDic;
    }
    NSError *err;
    if (tempAllusers.managedObjectContext.hasChanges) {
        if (![tempAllusers.managedObjectContext save:&err]) {
            result = @"同步contact信息至数据源失败";
            NSLog(@"-(NSString*)synchronizeContactInfo:(AllUsers*)contact toUser:(User*)user失败,error:%@",err);
            return result;
        }
        NSLog(@"数据源contact信息同步成功，%@",tempAllusers.wiiContact);
        result = @"同步contact信息至数据源成功";
    }
    
    return result;
    
//    NSString *result;
//    //获取数据源中本地帐号的信息
//    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [userInfoDic setValue:user.wiiID forKey:@"wiiID"];
//    AllUsers *tempAllusers = [AllUsers getUserFromDataSourceWithInfo1:userInfoDic];
//    if (tempAllusers.wiiError!=nil) {
//        result = tempAllusers.wiiError;
//        return result;
//    }
//    //替换数据源中对应本地帐号的contact数据
//    if (tempAllusers.wiiContact!=nil) {
//        NSMutableDictionary *tempUserContactDic = [NSJSONSerialization JSONObjectWithData:tempAllusers.wiiContact options:NSJSONReadingMutableContainers error:nil];
//        [tempUserContactDic setValue:contact.wiiID forKey:[NSString stringWithFormat:@"wiiID=%@",contact.wiiID]];
//        NSLog(@"tempAllusers.wiiContact = %@",tempAllusers.wiiContact);
//        NSLog(@"tmepUserContactDic = %@",tempUserContactDic);
//        NSData *tempData = [NSJSONSerialization dataWithJSONObject:tempUserContactDic options:NSJSONWritingPrettyPrinted error:nil];
//        tempAllusers.wiiContact = tempData;
//    }else{
//        NSMutableDictionary *tempUserContactDic = [NSMutableDictionary dictionaryWithCapacity:1];
//        [tempUserContactDic setValue:contact.wiiID forKey:[NSString stringWithFormat:@"wiiID=%@",contact.wiiID]];
//        NSData *tempData = [NSJSONSerialization dataWithJSONObject:tempUserContactDic options:NSJSONWritingPrettyPrinted error:nil];
//        tempAllusers.wiiContact = tempData;
//
//    }
//    NSError *err;
//    if (tempAllusers.managedObjectContext.hasChanges) {
//        if (![tempAllusers.managedObjectContext save:&err]) {
//            result = @"同步contact信息至数据源失败";
//            NSLog(@"-(NSString*)synchronizeContactInfo:(AllUsers*)contact toUser:(User*)user失败,error:%@",err);
//            return result;
//        }
//    }
//    
//    result = @"同步contact信息至数据源成功";
//    return result;
    
}
@end
