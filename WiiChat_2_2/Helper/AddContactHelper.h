//
//  AddContactHelper.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiChatSingletonClass.h"
#import "User.h"
#import "Contact.h"
#import "AllUsers.h"
@interface AddContactHelper : NSObject
WiiSingletonClass_Header(AddContactHelper)
-(id)searchSourceDataSourceWithInfo:(NSMutableDictionary*)info;
-(BOOL)isFriendContact:(AllUsers*)userInfo;
-(NSString*)synchronizeContactInfo:(AllUsers*)contact toUser:(User*)user;
@end
