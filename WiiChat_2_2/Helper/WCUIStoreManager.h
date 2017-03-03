//
//  WCUIStoreManager.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/8.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiChatSingletonClass.h"

@interface WCUIStoreManager : NSObject
WiiSingletonClass_Header(WCUIStoreManager)
-(NSMutableArray*)getProfileUIDataSource;
-(NSMutableArray*)getAddContactUIDataSource;
-(NSMutableArray*)getContactInfoUIDataSource;
-(NSMutableArray*)getRootContactUIDataSource;
@end
