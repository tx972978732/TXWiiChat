//
//  UserSource.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/3.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "User.h"
#import "Contact.h"
#import "AllUsers.h"
#import "WiiChatCoreDataStackManager.h"
#import "ErrorInfo.h"
#import "WCEditUserInfoTableViewController.h"//**** 将控制器从视图及数据库中分离

@interface UserSource : NSObject
-(id)insertUserWithID:(NSString*)ID Password:(NSString*)password;//登录 字典传递
-(id)insertUserWithID1:(NSString*)ID Password:(NSString*)password;//登录
-(NSString*)insertUser:(User*)user;//确认顶号登录
-(User*)getUser;//本地查询
-(NSMutableDictionary*)getUserInfo;
-(NSString*)resignUser;//注销 字典
-(NSString*)resignUser1;
-(AllUsers*)checkUserInDatabaseWithID:(NSString*)ID Password:(NSString*)password;//数据源查询
-(NSMutableDictionary*)checkUserInDatabaseWithID1:(NSString*)ID Password:(NSString*)password;//数据源查询 字典传递
-(AllUsers*)synchronousDataBaseWithUser:(User*)user;//数据源同步
-(NSString*)synchronousDataBaseWithUser1:(NSMutableDictionary*)userInfo;//数据源同步 字典传递
-(NSString*)synchronousLocalWithUserInfo:(NSMutableDictionary*)userinfo;//本地同步 字典
-(User*)synchronousLocalWithUser:(User*)user;//本地同步

@end
