//
//  EditUserInfoHelper.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/14.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiChatSingletonClass.h"
#import "User.h"
@interface EditUserInfoHelper : NSObject
WiiSingletonClass_Header(EditUserInfoHelper)
-(NSString*)saveChangesWithUserInfo:(NSMutableDictionary*)userInfo editChangetype:(userInfoEditType)type;
//-(NSString*)saveChangesInUserWithUserInfo:(NSMutableDictionary*)userInfo editChangeType:(userInfoEditType)type;
@end
