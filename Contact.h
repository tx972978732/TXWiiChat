//
//  Contact+CoreDataClass.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/12/1.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Contact : NSManagedObject
+ (NSFetchedResultsController*)contactFetchedResultsController;
+ (NSString*)convertRowNameFromWiiName:(NSString*)wiiName;//中文字符转拼音（不带音标）--get rowName
+ (NSString*)convertSectionNameFromWiiName:(NSString*)wiiName;//---get sectionName
@end

NS_ASSUME_NONNULL_END

#import "Contact+CoreDataProperties.h"
