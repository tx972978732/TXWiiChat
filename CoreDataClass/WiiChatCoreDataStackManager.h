//
//  WiiChatCoreDataStackManager.h
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WiiChatSingletonClass.h"


@interface WiiChatCoreDataStackManager : NSObject
//WiiSingletonClass_Header(WiiChatCoreDataStackManager)//单例方法
@property(nonatomic,readonly) NSManagedObjectContext* managedObjectContext;
@property(nonatomic,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,readonly) NSManagedObjectContext* sourceManagedObjectContext;
@property(nonatomic,readonly) NSPersistentStoreCoordinator *sourcePersistentStoreCoordinator;
+ (instancetype)sharedManager;
-(NSPersistentStoreCoordinator*)PersistentStoreCoordinatorWithModel:(NSManagedObjectModel*)model;
-(NSManagedObjectModel*)NSManagedObjectModelWithModelName:(NSString*)modelName;
-(NSManagedObjectContext*)NSManagedObjectContextWithPSC:(NSPersistentStoreCoordinator*)PSC;
@end
