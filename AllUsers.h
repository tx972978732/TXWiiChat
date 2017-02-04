//
//  AllUsers+CoreDataClass.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/30.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AllUsers : NSManagedObject
+(instancetype)insertUserWithName:(NSString*)name Password:(NSString*)password andEmail:(NSString*)email;
+(AllUsers*)getUserFromDataSourceWithInfo1:(NSMutableDictionary*)info;
+(NSMutableDictionary*)getUserFromDataSourceWithInfo:(NSMutableDictionary*)info;
+(NSString*)resignUserInDataBaseWithID:(NSString*)userID;

@end

NS_ASSUME_NONNULL_END

#import "AllUsers+CoreDataProperties.h"
