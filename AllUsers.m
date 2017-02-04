//
//  AllUsers+CoreDataClass.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/30.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "AllUsers.h"
#import "WiiChatCoreDataStackManager.h"
#import "ErrorInfo.h"

static NSMutableDictionary *allUsersInfoDic;
@implementation AllUsers
+(instancetype)insertUserWithName:(NSString*)name Password:(NSString*)password andEmail:(NSString*)email{
    NSManagedObjectContext *context = [AllUsers getSourceMOC];
    AllUsers *user = [NSEntityDescription insertNewObjectForEntityForName:@"AllUsers" inManagedObjectContext:context];
    user.wiiName = name;
    user.wiiPassword = password;
    user.wiiEmail = email;
    user.wiiHeadImg = UIImagePNGRepresentation([UIImage imageNamed:@"DefaultHeadImg"]);
    NSString *tempNum = [AllUsers generateNewID];
    NSLog(@"%@",tempNum);
    user.wiiID = tempNum;
    NSError *err;
    if ([AllUsers getSourceMOC].hasChanges) {
        [[AllUsers getSourceMOC] save:&err];
    }
    if(err){
        NSLog(@"存储失败,error:%@",err);
    }
    
    
    return user;
}

+(NSString*)generateNewID{
    static  NSInteger integerValue = 0;
    //硬查找，将所有信息放入内存排序，找到最大ID，返回”ID+1“。 消耗过多内存，待优化。
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
    //request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",self];
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"wiiID" ascending:NO]];
    NSError *err;
    NSArray<AllUsers*> *resultArr = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"检索ID失败，error:%@",err);
        return nil;
    }else{
        if (resultArr.count==0) {
            NSString * newID = @"1";
            return newID;
        }else{
            for (AllUsers *temp in resultArr) {
                NSInteger tempValue = [temp.wiiID integerValue];
                if (tempValue>integerValue) {
                    integerValue = tempValue;
                }
            }
            NSString *sortResult = [NSString stringWithFormat:@"%ld",(long)integerValue+1];
            return sortResult;
        }}
    
}
+(NSMutableDictionary*)getUserFromDataSourceWithInfo:(NSMutableDictionary *)info{
    AllUsers *tempUser;
    allUsersInfoDic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *info_ID = [info valueForKey:@"wiiID"];
    NSString *info_name = [info valueForKey:@"wiiName"];
    if (info_ID) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",info_ID];
        NSError *err;
        NSArray<AllUsers*> *result = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
        if (err) {
            NSLog(@"查找该用户失败<+(NSMutableDictionary*)getUserFromDataSourceWithInfo>,Error:%@",err);
            [allUsersInfoDic setValue:@"查找该用户失败" forKey:@"wiiError"];
            return allUsersInfoDic;
        }else{
            if (result.count) {
                //                [result enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                    [AllUsers copyAllUser:obj toUserInfoDic:tempDic];
                //                    NSLog(@"resultUser:%@",obj);
                //                }];
                tempUser = [result firstObject];
                [AllUsers copyAllUser:tempUser toUserInfoDic:tempDic];
                NSLog(@"tempDic:%@",tempDic);
                return tempDic; //查找成功 返回查找结果
            }else{
                NSLog(@"数据库中无此ID对象");
                [allUsersInfoDic setValue:Error_002 forKey:@"wiiError"];
                return allUsersInfoDic;
            }
        }
    }else if(info_name){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        request.predicate = [NSPredicate predicateWithFormat:@"wiiName = %@",info_name];
        NSError *err;
        NSArray<AllUsers*> *result = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
        if (err) {
            NSLog(@"查找该用户失败,Error:%@",err);
            [allUsersInfoDic setValue:@"查找该用户失败" forKey:@"wiiError"];
            return allUsersInfoDic;
        }else{
            if (result.count) {
                [AllUsers copyAllUser:[result firstObject] toUserInfoDic:allUsersInfoDic];
                return allUsersInfoDic; //查找成功 返回查找结果
            }else{
                NSLog(@"数据库中无此Name对象");
                [allUsersInfoDic setValue:Error_003 forKey:@"wiiError"];
                return allUsersInfoDic;
            }
        }
    }
    NSLog(@"info中无可用的查找信息");
    [allUsersInfoDic setValue:Error_004 forKey:@"wiiError"];
    return allUsersInfoDic;
    
}
+(AllUsers*)getUserFromDataSourceWithInfo1:(NSMutableDictionary *)info{
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"AllUsers" inManagedObjectContext:[AllUsers getSourceMOC]];
    //创建一个管理对象，但不插入MOC中
    AllUsers *sourceUser = [[AllUsers alloc]initWithEntity:ent insertIntoManagedObjectContext:nil];
    NSString *info_ID = [info valueForKey:@"wiiID"];
    NSString *info_name = [info valueForKey:@"wiiName"];
    if (info_ID) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",info_ID];
        NSError *err;
        NSArray<AllUsers*> *result = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
        if (err) {
            NSLog(@"查找该用户失败,Error:%@",err);
            sourceUser.wiiError = Error_001;
            return sourceUser;
        }else{
            if (result.count) {
                //sourceUser = [result firstObject];
                return [result firstObject]; //查找成功 返回查找结果
            }else{
                NSLog(@"数据库中无此ID对象");
                sourceUser.wiiError = Error_002;
                return sourceUser;
            }
        }
    }else if(info_name){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        request.predicate = [NSPredicate predicateWithFormat:@"wiiName = %@",info_name];
        NSError *err;
        NSArray<AllUsers*> *result = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
        if (err) {
            NSLog(@"查找该用户失败,Error:%@",err);
            sourceUser.wiiError = Error_001;
            return sourceUser;
        }else{
            if (result.count) {
                //sourceUser = [result firstObject];
                return [result firstObject];
            }else{
                NSLog(@"数据库中无此Name对象");
                sourceUser.wiiError = Error_003;
                return sourceUser;
            }
        }
    }
    NSLog(@"info中无可用的查找信息");
    sourceUser.wiiError = Error_004;
    return sourceUser;
}

+(NSString*)resignUserInDataBaseWithID:(NSString*)userID{
    NSString *resignResult;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
    request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",userID];
    NSError *err;
    NSArray<AllUsers*> *result = [[AllUsers getSourceMOC] executeFetchRequest:request error:&err];
    [result firstObject].wiiLogin = @"NO";
    if ([AllUsers getSourceMOC].hasChanges) {
        [[AllUsers getSourceMOC] save:nil];
    }
    if (err) {
        NSLog(@"注销用户失败(数据源),Error:%@",err);
        resignResult = @"数据源注销失败";
        return resignResult;
    }
    NSLog(@"已在数据源中注销用户登录");
    resignResult = @"注销成功";
    return resignResult;
}

+(void)copyAllUser:(AllUsers*)allUser toUserInfoDic:(NSMutableDictionary*)userInfoDic{
    [userInfoDic setValue:allUser.wiiName forKey:@"wiiName"];
    [userInfoDic setValue:allUser.wiiID forKey:@"wiiID"];
    [userInfoDic setValue:allUser.wiiPassword forKey:@"wiiPassword"];
    [userInfoDic setValue:allUser.wiiEmail forKey:@"wiiEmail"];
    [userInfoDic setValue:allUser.wiiLogin forKey:@"wiiLogin"];
    [userInfoDic setValue:allUser.wiiSex forKey:@"wiiSex"];
    [userInfoDic setValue:allUser.wiiSignature forKey:@"wiiSignature"];
    [userInfoDic setValue:allUser.wiiHeadImg forKey:@"wiiHeadImg"];
    [userInfoDic setValue:allUser.wiiContact forKey:@"wiiContact"];
    [userInfoDic setValue:allUser.wiiAddress forKey:@"wiiAddress"];
}
+(NSManagedObjectContext*)getSourceMOC{
    return [[WiiChatCoreDataStackManager sharedManager] sourceManagedObjectContext];
    
}
@end
