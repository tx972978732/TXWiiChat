//
//  User+CoreDataClass.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "User.h"
#import "Contact.h"


static NSMutableDictionary *sourceResultDic;
static NSMutableDictionary *tempResultDic;
static NSMutableDictionary *userInfoDic;
static NSManagedObjectContext *localManagedObjectContext;

@implementation User

+(instancetype)insertUserWithID1:(NSString*)ID Password:(NSString*)password{
    AllUsers *requestUser = [User checkUserInDatabaseWithID:ID Password:password];
    NSLog(@"查询数据源结果:%@",requestUser);
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[User localMOC]];
    User *newUser = [[User alloc]initWithEntity:ent insertIntoManagedObjectContext:nil];
    //检索错误信息
    if (requestUser.wiiError!=nil) {//若有错误信息 则直接返回错误信息
        newUser.wiiError = requestUser.wiiError;
        return newUser;
    }else{
        if ([requestUser.wiiLogin isEqualToString:@"NO"])//NO-未在其他设备上登录
        {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
            request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",requestUser.wiiID];
            NSError *err2;
           NSArray<AllUsers*> *result = [[User sourceMOC] executeFetchRequest:request error:&err2];
            NSLog(@"101查找结果：%@",[result firstObject]);
            [result firstObject].wiiLogin = @"YES";
////            [result enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                obj.wiiLogin = @"YES";
////            }];
            if ([User sourceMOC].hasChanges) {
                [[User sourceMOC] save:nil];
            }
            if (err2) {
                NSLog(@"存储信息至数据源失败,Error:%@",err2);
                newUser.wiiError = Error_008;
                return newUser;
            }
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
            request1.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",requestUser.wiiID];
            NSError *err3;
            NSArray<AllUsers*> *result1 = [[User sourceMOC] executeFetchRequest:request1 error:&err3];
            NSLog(@"102查找结果：%@",[result1 firstObject]);
            NSError *err1;
            requestUser.wiiLogin = @"YES";
            if ([User sourceMOC].hasChanges) {
                [[User sourceMOC] save:&err1];
            }
            if (err1) {
                newUser.wiiError = Error_008;
                NSLog(@"数据库异常登录失败：error:%@",err1);
                return newUser;
            }
            requestUser = [User checkUserInDatabaseWithID:ID Password:password];//修改数据源login信息后重新获取数据源信息
            if ([requestUser.wiiLogin isEqualToString:@"YES"]) {
                [User copyInfoFromAllUser:requestUser ToUser:newUser];
                newUser.wiiLogin = @"YES_Pass";//通过验证且未在其他设备上登录
                
                NSError *err2;
                if ([User localMOC].hasChanges) {
                    [[User localMOC] save:&err2];
                }
                if(err2){
                    NSLog(@"存储用户信息至本地失败,Error:%@",err2);
                    newUser.wiiError = Error_001;
                    return newUser;
                }else{
                    return newUser;//存储至本地成功，返回newUser
                }
            }
        }else if ([requestUser.wiiLogin isEqualToString:@"YES"]){  //*****增加顶号登录 风险提示
            [User copyInfoFromAllUser:requestUser ToUser:newUser];
            newUser.wiiLogin = @"YES_AlreadyLogin";//通过验证且已在其他设备上登录 是否顶替？
            return newUser;
        }
    }
    newUser.wiiError = @"数据异常抛出";
    return newUser;
}
+(id)insertUserWithID:(NSString*)ID Password:(NSString*)password{
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[User localMOC]];
    sourceResultDic = [NSMutableDictionary dictionaryWithCapacity:10];
    sourceResultDic = [User checkUserInDatabaseWithID1:ID Password:password];
    NSLog(@"查询数据源结果:%@",sourceResultDic);
    //检索错误信息
    if ([sourceResultDic valueForKey:@"wiiError"]!=nil) {//若有错误信息 则直接返回错误信息
        newUser.wiiError = [sourceResultDic valueForKey:@"wiiError"];
        return newUser;
    }else{
        if ([[sourceResultDic valueForKey:@"wiiLogin" ] isEqualToString:@"NO"])//NO-未在其他设备上登录
        {
            NSError *err1;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
            request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",ID];
            NSArray<AllUsers*> *result = [[User sourceMOC] executeFetchRequest:request error:&err1];
            [result enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.wiiLogin = @"YES";
            }];
            if ([User sourceMOC].hasChanges) {
                [[User sourceMOC] save:nil];
            }
            if (err1) {
                newUser.wiiError = Error_008;
                NSLog(@"数据库异常登录失败：error:%@",err1);
                return newUser;
            }
            //if ([requestUser.wiiLogin isEqualToString:@"YES"]) {
            [User copyInfoFromSourceUserDic:sourceResultDic toNewUser:newUser];
                newUser.wiiLogin = @"YES_Pass";//通过验证且未在其他设备上登录
            NSLog(@"插入本地数据库中内容为：%@",newUser);
                if ([User localMOC].hasChanges) {
                    [[User localMOC] save:nil];
                }
                    return newUser;//存储至本地成功，返回newUser
           // }
        }else if ([[sourceResultDic valueForKey:@"wiiLogin" ] isEqualToString:@"YES"])
        {  //*****增加顶号登录 风险提示
            [User copyInfoFromSourceUserDic:sourceResultDic toNewUser:newUser];
            newUser.wiiLogin = @"YES_AlreadyLogin";//通过验证且已在其他设备上登录 是否顶替？
            return newUser;
        }
    }
    newUser.wiiError = @"数据异常抛出";
    return newUser;
}
+(NSString*)insertUser:(User*)user{//顶号登录
    NSString *result;
    User *newUser = user;
    [[User localMOC] insertObject:newUser];
    NSError *err;
    if ([User localMOC].hasChanges) {
        [[User localMOC] save:&err];
    }
    if (err) {
        NSLog(@"存储用户信息失败2,Error:%@",err);
        result = @"存储用户失败，请联系管理员";
        return result;
    }else{
        result = @"存储用户信息成功";
        return result;
    }
}


+(User*)getUser{
    NSFetchRequest *requset = [[NSFetchRequest alloc]init];
    requset.entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[User localMOC]];
    //[NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *err;
    NSArray<User*> *result = [[User localMOC] executeFetchRequest:requset error:&err];
    requset = nil;
    if (err) {
        NSLog(@"<+(User*)getUser>获取已登录用户信息失败,Error：%@",err);
        [result firstObject].wiiError = Error_001;
        return [result firstObject];
    }else{
        NSLog(@"UserInfo:%@",[result firstObject]);
        return [result firstObject];
    }
}
+(NSMutableDictionary*)getUserInfo{
//    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:10];
//    NSFetchRequest *requset = [NSFetchRequest fetchRequestWithEntityName:@"User"];
//    NSError *err;
//    NSArray<User*> *result = [[User localMOC] executeFetchRequest:requset error:&err];
//    if (err) {
//        NSLog(@"获取已登录用户信息失败,Error：%@",err);
//        [resultDic setValue:@"获取已登录用户信息失败" forKey:@"wiiError"];
//        return resultDic;
//    }else{
//        [result enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [User copyInfoFromUser:obj toUserInfoDic:resultDic];
//        }];
//        return resultDic;
//    }
    if (userInfoDic==nil) {
        userInfoDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    }
    [User copyInfoFromUser:[User getUser] toUserInfoDic:userInfoDic];
    return userInfoDic;
}
+(NSString*)resignUser1{
    NSString *resignResult;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    User *tempUser = [User getUser];
    if ([tempUser.wiiID isEqualToString:@""]) {
        resignResult = @"数据异常，强制退出登录";
        return resignResult;
    }
    else{
        [tempDic setValue:tempUser.wiiID forKey:@"wiiID"];
        [tempDic setValue:tempUser.wiiName forKey:@"wiiName"];
        AllUsers *sourceUsers = [AllUsers getUserFromDataSourceWithInfo1:tempDic];
        if (sourceUsers.wiiError!=nil) {//确定数据源中存在该帐号   ****是否有必要确认？
            resignResult = sourceUsers.wiiError;
            return resignResult;
        }else{
////            NSFetchRequest *requst1 = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
////            requst1.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",sourceUsers.wiiID];
////            NSError *err1;
////            NSArray<AllUsers*> *result1 = [[User sourceMOC] executeFetchRequest:requst1 error:&err1];
////            [result1 enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                obj.wiiLogin = @"NO";
////            }];
            sourceUsers.wiiLogin = @"NO";
            if ([User sourceMOC].hasChanges) {
                [[User sourceMOC] save:nil];
            }
////            if (err1) {
////                resignResult = @"数据库异常，注销失败";   //对数据源login信息进行修改 修改成功后进行本地注销
////                return resignResult;
////            }
            //删除User信息
            NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"User"];
            NSError *err2;
            NSArray<User*> *result2 = [[User localMOC] executeFetchRequest:request2 error:&err2];
            [result2 enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[User localMOC] deleteObject:obj];
            }];
            if ([User localMOC].hasChanges) {
                [[User localMOC] save:nil];
            }
            if (err2) {
                resignResult = @"删除本地数据失败，请稍后重试"; //****** 已在数据源修改后，本地修改失败，应添加其他跳转方法避免再次修改数据源
                return resignResult;
            }
            //删除Contact信息
            NSFetchRequest *request3 = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
            NSError *err3;
            NSArray<Contact*> *result3 = [[User localMOC]executeFetchRequest:request3 error:&err3];
            [result3 enumerateObjectsUsingBlock:^(Contact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[User localMOC] deleteObject:obj];
            }];
            if ([User localMOC].hasChanges) {
                [[User localMOC] save:nil];
            }
            if (err3) {
                NSLog(@"本地contact信息删除失败");
                resignResult = @"数据异常，强制退出登录";
                return resignResult;
                //***本地contact信息删除失败后 应添加其他方法重试或恢复数据
            }
            resignResult = @"已注销用户";
            return resignResult;
        }
    }

}
+(NSString*)resignUser{
////    NSString *localResignResult;
////    NSString *sourceResignResult;
////    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
////    request.predicate = [NSPredicate predicateWithFormat:@"wiiLogin = %@",@"YES_Pass"];
////    NSError *err1;
////    NSArray<User*> *result = [[User localMOC] executeFetchRequest:request error:&err1];
////    if (err1) {
////        NSLog(@"查找User信息失败,Error:%@",err1);
////        localResignResult = @"查找用户信息失败";
////        return localResignResult;
////    }else{
////        if (result.count) {
////         sourceResignResult = [AllUsers resignUserInDataBaseWithID:[result firstObject].wiiID];
////            if (![sourceResignResult isEqualToString:@"注销成功"]) {
////                localResignResult = @"注销数据源用户失败";
////                return localResignResult; //数据源信息更改 login信息
////            }
////            for (NSManagedObject * obj in result) {
////                [[User localMOC] deleteObject:obj];
////            }
////            NSError *err2;
////            if ([User localMOC].hasChanges) {
////                [[User localMOC] save:&err2];
////            }
////            if (err2) {
////                NSLog(@"删除User失败,Error:%@",err2);
////                localResignResult = @"注销本地User失败";
////                return localResignResult;
////            }else{
////                localResignResult = @"已注销用户";
////                return localResignResult;
////            }
////        }
////        return localResignResult;
////    }
    NSString *resignResult;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableDictionary *checkDataSourceResultDic = [NSMutableDictionary dictionaryWithCapacity:10];
    tempDic = [User getUserInfo];
    if ([tempDic valueForKey:@"wiiID"]==nil) {
        resignResult = @"数据异常，强制退出登录";
        return resignResult;
    }
    else{
    checkDataSourceResultDic = [AllUsers getUserFromDataSourceWithInfo:tempDic];
    if ([checkDataSourceResultDic valueForKey:@"wiiError"]!=nil) {
        resignResult = [checkDataSourceResultDic valueForKey:@"wiiError"];
        return resignResult;
    }else{
        NSFetchRequest *requst1 = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        requst1.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",[checkDataSourceResultDic valueForKey:@"wiiID"]];
        NSError *err1;
        NSArray<AllUsers*> *result1 = [[User sourceMOC] executeFetchRequest:requst1 error:&err1];
        [result1 enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.wiiLogin = @"NO";
        }];
        if ([User sourceMOC].hasChanges) {
            [[User sourceMOC] save:nil];
        }
        if (err1) {
            resignResult = @"数据库异常，注销失败";   //对数据源login信息进行修改 修改成功后进行本地注销
            return resignResult;
        }
        NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSError *err2;
        NSArray<User*> *result2 = [[User localMOC] executeFetchRequest:request2 error:&err2];
        [result2 enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[User localMOC] deleteObject:obj];
        }];
        if ([User localMOC].hasChanges) {
            [[User localMOC] save:nil];
        }
        if (err2) {
            resignResult = @"删除本地数据失败，请稍后重试"; //****** 已在数据源修改后，本地修改失败，应添加其他跳转方法避免再次修改数据源
            return resignResult;
        }
        resignResult = @"已注销用户";
        return resignResult;
    }
    }
}
+(AllUsers*)checkUserInDatabaseWithID:(NSString*)ID Password:(NSString*)password{
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"AllUsers" inManagedObjectContext:[User sourceMOC]];
    AllUsers *sourceUser = [[AllUsers alloc]initWithEntity:ent insertIntoManagedObjectContext:nil];
    //查询数据库待改为从非本地数据中获取信息，应添加网络请求等方法
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:ID forKey:@"wiiID"];
    AllUsers *tempUser = [AllUsers getUserFromDataSourceWithInfo1:dic];
    //检索错误信息
    if (tempUser.wiiError!=nil) {//若有错误信息则直接返回搜索错误信息
        sourceUser.wiiError = tempUser.wiiError;
        return sourceUser;
    }else{
        if (tempUser.wiiID) {
            if ([tempUser.wiiPassword isEqualToString:password]) {
                //sourceUser = tempUser;  //无法直接复制对象？
                return tempUser;
            }
            else{
                sourceUser.wiiError = Error_005;
                return sourceUser;
            }
        }else{
            sourceUser.wiiError = Error_006;
            return sourceUser;
        }
        
    }
}
+(NSMutableDictionary*)checkUserInDatabaseWithID1:(NSString*)ID Password:(NSString*)password{
    //查询数据库待改为从非本地数据中获取信息，应添加网络请求等方法
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:ID forKey:@"wiiID"];
    tempResultDic = [NSMutableDictionary dictionaryWithCapacity:10];
   tempResultDic = [AllUsers getUserFromDataSourceWithInfo:dic];
    //检索错误信息
    if ([tempResultDic valueForKey:@"wiiError"]!=nil)
    {//若有错误信息则直接返回搜索错误信息
        return tempResultDic;
    }
    else{
        if ([tempResultDic valueForKey:@"wiiID"]!=nil)
        {
            if ([[tempResultDic valueForKey:@"wiiPassword" ] isEqualToString:password])
            {
                //sourceUser = tempUser;  //无法直接复制对象？
                return tempResultDic;
            }
            else{
                [tempResultDic setValue:Error_005 forKey:@"wiiError"];
                return tempResultDic;
            }
        }
        else{
            //[tempResultDic setValue:Error_006 forKey:@"wiiError"];  //若帐号错误 无法流转至此处
            [tempResultDic setValue:@"程序异常查找失败" forKey:@"wiiError"];
            return tempResultDic;
        }
        
        }
}

+(AllUsers*)synchronousDataBaseWithUser:(User*)user{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:user.wiiID forKey:@"wiiID"];
    AllUsers *sourceUser = [AllUsers getUserFromDataSourceWithInfo1:dic];
    if (sourceUser.wiiError!=nil) {
        return sourceUser;//查找出现错误 返回错误信息
    }else{
        NSError *err;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
        request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",user.wiiID];
        NSArray<AllUsers*> *result = [[User sourceMOC] executeFetchRequest:request error:&err];
        [result enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [User copyInfoFromUser:user toAllUsers:obj];
        }];
        if ([User sourceMOC].hasChanges) {
            [[User sourceMOC] save:&err];
        }
        if (err) {
            sourceUser.wiiError = Error_007;
            return sourceUser;//存储出现错误 返回错误信息
        }
        return sourceUser;
    }
}
+(User*)synchronousLocalWithUser:(User*)user{
    User *resultUser = user;
    NSError *err;
    if ([User localMOC].hasChanges) {
        [[User localMOC] save:&err];
    }
    if (err) {
        resultUser.wiiError = Error_007;
        return resultUser;
    }
    return resultUser;
}
+(NSString*)synchronousDataBaseWithUser1:(NSMutableDictionary *)userInfo{
    NSString *resultStr;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
    request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",[userInfo valueForKey:@"wiiID"]];
    NSError *err;
    NSArray<AllUsers*> *result = [[User sourceMOC] executeFetchRequest:request error:&err];
    [result enumerateObjectsUsingBlock:^(AllUsers * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [User copyInfoFromLocalUserDic:userInfo toAllUsers:obj];
    }];
    if ([User sourceMOC].hasChanges) {
        [[User sourceMOC] save:nil];
    }
    if (err) {
        resultStr = @"修改数据源信息出错";
        return resultStr;
    }
    resultStr = @"数据源同步成功";
    return resultStr;
}

+(NSString*)synchronousLocalWithUserInfo:(NSMutableDictionary*)userinfo{
    NSString *resultStr;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",[userinfo valueForKey:@"wiiID"]];
    NSError *err;
    NSArray<User*> *result = [[User localMOC] executeFetchRequest:request error:&err];
    [result enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [User copyInfoFromLocalUserDic:userinfo toUser:obj];
    }];
    if (err) {
        resultStr = @"修改本地信息出错";
        return resultStr;
    }
    resultStr = @"本地同步成功";
    return resultStr;
}

+(NSManagedObjectContext*)sourceMOC{
    return [[WiiChatCoreDataStackManager sharedManager]sourceManagedObjectContext];
}

-(NSManagedObjectContext *)localManagedObjectContext{
    if (localManagedObjectContext) {
        return localManagedObjectContext;
    }
    
    localManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    localManagedObjectContext.persistentStoreCoordinator = [[WiiChatCoreDataStackManager sharedManager] persistentStoreCoordinator];
    
    return localManagedObjectContext;

}

+(NSManagedObjectContext*)localMOC{
    return [[WiiChatCoreDataStackManager sharedManager]managedObjectContext];
}
+(void)copyInfoFromAllUser:(AllUsers*)allusers ToUser:(User*)user{
    //循环读出user的contact信息 并存储在local中
////NSData方案：
////    NSMutableDictionary *contactDic = [NSJSONSerialization JSONObjectWithData:allusers.wiiContact options:NSJSONReadingMutableContainers error:nil];
////    NSLog(@"数据源contact信息：%@",allusers.wiiContact);
////    NSLog(@"解码后Contact信息：%@",contactDic);
////    for (NSString *obj in contactDic) {
////        NSLog(@"解码后Contact info 信息：%@",contactDic[obj]);
////        Contact *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:[User localMOC]];
////        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
////        request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",contactDic[obj]];
////        NSArray<AllUsers*> *resultArray = [[User sourceMOC]executeFetchRequest:request error:nil];
////        [User copyInfoFromDataSource:[resultArray firstObject] toContact:contactInfo];
////        [user addContactObject:contactInfo];
//
////    }
//
////Transformable方案：
    NSLog(@"数据源contact信息:%@",allusers.wiiContact);
    if (allusers.wiiContact!=nil) {
        for (id obj in allusers.wiiContact) {
            NSLog(@"解码后Contact info 信息：%@",obj);
            Contact *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:[User localMOC]];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AllUsers"];
            request.predicate = [NSPredicate predicateWithFormat:@"wiiID = %@",allusers.wiiContact[obj]];
            NSArray<AllUsers*> *resultArray = [[User sourceMOC] executeFetchRequest:request error:nil];
            [User copyInfoFromDataSource:[resultArray firstObject] toContact:contactInfo];
            NSLog(@"从数据中获取contactInfo 信息:%@",contactInfo);
            //保存contact信息
            NSError *err;
            if ([User localMOC].hasChanges) {
                [[User localMOC] save:&err];
            }
            [[User localMOC] insertObject:user];
            [user addContactObject:contactInfo];//****直接addContact？
        }
    }
     [[User localMOC] insertObject:user];
    // user.wiilogin = allusers.wiilogin;//确定是否允许登录
    user.wiiPassword = allusers.wiiPassword;
    user.wiiID = allusers.wiiID;
    user.wiiSex = allusers.wiiSex;
    user.wiiName = allusers.wiiName;
    user.wiiPhoto = allusers.wiiPhoto;//可改为需要时再获取 已节省网络流量
    user.wiiAddress = allusers.wiiAddress;
    user.wiiHeadImg = allusers.wiiHeadImg;
    user.wiiSignature = allusers.wiiSignature;
    user.wiiEmail = allusers.wiiEmail;
}
+(void)copyInfoFromUser:(User*)user ToNewUser:(User*)newUser{
    newUser.wiiPassword = user.wiiPassword;
    newUser.wiiID = user.wiiID;
    newUser.wiiSex = user.wiiSex;
    newUser.wiiName = user.wiiName;
    newUser.wiiPhoto = user.wiiPhoto;//可改为需要时再获取 已节省网络流量
    newUser.wiiAddress = user.wiiAddress;
    newUser.wiiHeadImg = user.wiiHeadImg;
    newUser.wiiSignature = user.wiiSignature;
    newUser.wiiEmail = user.wiiEmail;
    newUser.wiiLogin = user.wiiLogin;
    newUser.wiiError = user.wiiError;
}
+(void)copyInfoFromUser:(User*)user toAllUsers:(AllUsers*)allUser{
    //修改用户基本信息 ID、Email 不允许修改
    allUser.wiiPassword = user.wiiPassword;
    //allUser.wiiID = user.wiiID;
    allUser.wiiSex = user.wiiSex;
    allUser.wiiName = user.wiiName;
    allUser.wiiPhoto = user.wiiPhoto;//可改为需要时再获取 已节省网络流量
    allUser.wiiAddress = user.wiiAddress;
    allUser.wiiHeadImg = user.wiiHeadImg;
    allUser.wiiSignature = user.wiiSignature;
    //allUser.wiiEmail = user.wiiEmail;
}
+(void)copyInfoFromSourceUserDic:(NSMutableDictionary*)dic toNewUser:(User*)user{
    user.wiiPassword = [dic valueForKey:@"wiiPassword"];
    user.wiiID = [dic valueForKey:@"wiiID"];
    user.wiiSex = [dic valueForKey:@"wiiSex"];
    user.wiiName = [dic valueForKey:@"wiiName"];
    //user.wiiPhoto = [dic valueForKey:@"wiiPassword"];//可改为需要时再获取 已节省网络流量
    user.wiiAddress = [dic valueForKey:@"wiiAddress"];
    user.wiiHeadImg = [dic valueForKey:@"wiiHeadImg"];
    user.wiiSignature = [dic valueForKey:@"wiiSignature"];
    user.wiiEmail = [dic valueForKey:@"wiiEmail"];
}
+(void)copyInfoFromLocalUserDic:(NSMutableDictionary*)dic toAllUsers:(AllUsers*)allUser{//修改数据源用户信息 调用
    allUser.wiiPassword = [dic valueForKey:@"wiiPassword"];
    //allUser.wiiID = [dic valueForKey:@"wiiID"];  //用户ID不允许修改
    allUser.wiiSex = [dic valueForKey:@"wiiSex"];
    allUser.wiiName = [dic valueForKey:@"wiiName"];
    //user.wiiPhoto = [dic valueForKey:@"wiiPassword"];//可改为需要时再获取 已节省网络流量
    allUser.wiiAddress = [dic valueForKey:@"wiiAddress"];
    allUser.wiiHeadImg = [dic valueForKey:@"wiiHeadImg"];
    allUser.wiiSignature = [dic valueForKey:@"wiiSignature"];
   // allUser.wiiEmail = [dic valueForKey:@"wiiEmail"]; //用户邮箱不允许修改
}
+(void)copyInfoFromLocalUserDic:(NSMutableDictionary*)dic toUser:(User*)user{//修改本地用户信息 调用
    user.wiiPassword = [dic valueForKey:@"wiiPassword"];
    //user.wiiID = [dic valueForKey:@"wiiID"];  //用户ID不允许修改
    user.wiiSex = [dic valueForKey:@"wiiSex"];
    user.wiiName = [dic valueForKey:@"wiiName"];
    //user.wiiPhoto = [dic valueForKey:@"wiiPassword"];//可改为需要时再获取 已节省网络流量
    user.wiiAddress = [dic valueForKey:@"wiiAddress"];
    user.wiiHeadImg = [dic valueForKey:@"wiiHeadImg"];
    user.wiiSignature = [dic valueForKey:@"wiiSignature"];
    // user.wiiEmail = [dic valueForKey:@"wiiEmail"]; //用户邮箱不允许修改
}
+(void)copyInfoFromUser:(User*)user toUserInfoDic:(NSMutableDictionary*)dic{
    [dic setValue:user.wiiPassword forKey:@"wiiPassword"];
    [dic setValue:user.wiiID forKey:@"wiiID"];
    [dic setValue:user.wiiSex forKey:@"wiiSex"];
    [dic setValue:user.wiiName forKey:@"wiiName"];
    [dic setValue:user.wiiAddress forKey:@"wiiAddress"];
    [dic setValue:user.wiiHeadImg forKey:@"wiiHeadImg"];
    [dic setValue:user.wiiSignature forKey:@"wiiSignature"];
    [dic setValue:user.wiiEmail forKey:@"wiiEmail"];
}
+(void)copyInfoFromDataSource:(AllUsers*)allUsers toContact:(Contact*)contact{
    contact.wiiID = allUsers.wiiID;
    contact.wiiName = allUsers.wiiName;
    contact.wiiHeadImg = allUsers.wiiHeadImg;
    contact.wiiSex = allUsers.wiiSex;
    contact.wiiEmail = allUsers.wiiEmail;
    contact.wiiSignature = allUsers.wiiSignature;
    contact.wiiAddress = allUsers.wiiAddress;
    contact.rowName = [Contact convertRowNameFromWiiName:contact.wiiName];
    contact.sectionName = [Contact convertSectionNameFromWiiName:contact.wiiName];
    //contact.wiiPhoto = allUsers.wiiPhoto;  需要时再加载
}

@end

