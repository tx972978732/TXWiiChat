//
//  RegisterHelper.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/9/29.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "RegisterHelper.h"
#import "AllUsers.h"
@interface RegisterHelper()
@property(nonatomic,assign)BOOL isEmailRegister;
@end

@implementation RegisterHelper
WiiSingletonClass_Implementation(RegisterHelper)

-(BOOL)isEmailRegistered:(NSString*)email{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AllUsers"];
    request.predicate = [NSPredicate predicateWithFormat:@"wiiEmail = %@",email];
    NSError *err;
    NSArray<AllUsers *> *result = [[[WiiChatCoreDataStackManager sharedManager]sourceManagedObjectContext] executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"检查邮箱是否已注册失败,error:%@",err);
        return YES;
    }else{
        if (result.count!=0) {
            NSLog(@"Email Result: %@, isEmailregister:%d",result,_isEmailRegister);
            NSLog(@"wiiname:%@",[result firstObject].wiiName);
            [self setIsEmailRegister:YES];
            return _isEmailRegister;
        }
        else{
            [self setIsEmailRegister:NO];
            return _isEmailRegister;
        }
    }
    
}

-(NSString*)registerUserWithInfo:(NSMutableDictionary*)info{
    NSString *name = [info valueForKey:@"name"];
    NSString *password = [info valueForKey:@"password"];
    NSString *email = [info valueForKey:@"email"];
    AllUsers *user = [AllUsers insertUserWithName:name Password:password andEmail:email];
    NSString *wiiChatID = [NSString stringWithFormat:@"%@",user.wiiID];
    return wiiChatID;
}

@end
