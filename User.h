//
//  User+CoreDataClass.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/7.
//  Copyright © 2016年 童煊. All rights reserved.
//
@import Foundation;
@import CoreData;
#import "WiiChatCoreDataStackManager.h"
#import "AllUsers.h"
#import "ErrorInfo.h"
#import "WCEditUserInfoTableViewController.h"//**** 将控制器从视图及数据库中分离

@class Contact;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject
+(id)insertUserWithID:(NSString*)ID Password:(NSString*)password;//登录 字典传递
+(instancetype)insertUserWithID1:(NSString*)ID Password:(NSString*)password;//登录
+(NSString*)insertUser:(User*)user;//确认顶号登录
+(User*)getUser;//本地查询
+(NSMutableDictionary*)getUserInfo;
+(NSString*)resignUser;//注销 字典
+(NSString*)resignUser1;
+(AllUsers*)checkUserInDatabaseWithID:(NSString*)ID Password:(NSString*)password;//数据源查询
+(NSMutableDictionary*)checkUserInDatabaseWithID1:(NSString*)ID Password:(NSString*)password;//数据源查询 字典传递
+(AllUsers*)synchronousDataBaseWithUser:(User*)user;//数据源同步
+(NSString*)synchronousDataBaseWithUser1:(NSMutableDictionary*)userInfo;//数据源同步 字典传递
+(NSString*)synchronousLocalWithUserInfo:(NSMutableDictionary*)userinfo;//本地同步 字典
+(User*)synchronousLocalWithUser:(User*)user;//本地同步
+(NSManagedObjectContext*)sourceMOC;
+(NSManagedObjectContext*)localMOC;
@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
