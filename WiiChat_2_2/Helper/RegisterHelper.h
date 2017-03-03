//
//  RegisterHelper.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/9/29.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiChatCoreDataStackManager.h"
#import "WiiChatSingletonClass.h"
@interface RegisterHelper : NSObject
WiiSingletonClass_Header(RegisterHelper)
-(BOOL)isEmailRegistered:(NSString*)email;
-(NSString*)registerUserWithInfo:(NSMutableDictionary*)info;
@end
