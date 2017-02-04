//
//  WiiChatCoreDataStackManager.m
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WiiChatCoreDataStackManager.h"

@interface WiiChatCoreDataStackManager ()

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong) NSManagedObjectContext *sourceManagedObjectContext;
@property(nonatomic,strong) NSPersistentStoreCoordinator *sourcePersistentStoreCoordinator;
@property(nonatomic,strong) NSManagedObjectModel *sourceManagedObjectModel;


@end
@implementation WiiChatCoreDataStackManager
//WiiSingletonClass_Implementation(WiiChatCoreDataStackManager)
+ (instancetype)sharedManager {
    
    static WiiChatCoreDataStackManager *sharedManager = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

//获取文件文件路径
-(NSString *)applicationDocumentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}

#pragma mark - 传参手动创建StackManager
-(NSManagedObjectModel*)NSManagedObjectModelWithModelName:(NSString*)modelName{
    NSURL *url = [[NSBundle mainBundle]URLForResource:modelName withExtension:@"mom"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:url];
    return model;
}

-(NSPersistentStoreCoordinator*)PersistentStoreCoordinatorWithModel:(NSManagedObjectModel*)model{
    NSString *path = [[self applicationDocumentsDirectory]stringByAppendingPathComponent:@"User+Contact.sqlite"];
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    NSError *error;
    //创建持久化控制器模型
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建持久化控制器管理表格，以SQlite方式存储
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:urlPath options:nil error:&error]) {
        NSLog(@"持久化存储表格生成失败：%@, %@",error,[error userInfo]);//错误输出
        abort();//终止程序
    }
    return psc;
}

-(NSManagedObjectContext*)NSManagedObjectContextWithPSC:(NSPersistentStoreCoordinator*)PSC{
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = PSC;
    return moc;
}






#pragma mark - 重写getter方法
-(NSManagedObjectModel*)managedObjectModel{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WiiChat_2_2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSString *path = [[self applicationDocumentsDirectory]stringByAppendingPathComponent:@"User+Contact.sqlite"];
    NSLog(@"%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"PSC生成SQlite表格失败：%@,%@",error,[error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext*)managedObjectContext{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return _managedObjectContext;
}

#pragma mark - 源数据getter方法
-(NSManagedObjectModel*)sourceManagedObjectModel{
    if (_sourceManagedObjectModel) {
        return _sourceManagedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WiiChatSourceData" withExtension:@"momd"];
    _sourceManagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _sourceManagedObjectModel;
}

-(NSPersistentStoreCoordinator*)sourcePersistentStoreCoordinator{
    if (_sourcePersistentStoreCoordinator) {
        return _sourcePersistentStoreCoordinator;
    }
    NSString *path = [[self applicationDocumentsDirectory]stringByAppendingPathComponent:@"AllUsers.sqlite"];
    NSLog(@"AllUsers.sqlite文件路径:%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    _sourcePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.sourceManagedObjectModel];
    if (![_sourcePersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"PSC生成SQlite表格失败：%@,%@",error,[error userInfo]);
        abort();
    }
    return _sourcePersistentStoreCoordinator;
}

-(NSManagedObjectContext*)sourceManagedObjectContext{
    if (_sourceManagedObjectContext) {
        return _sourceManagedObjectContext;
    }
    _sourceManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    _sourceManagedObjectContext.persistentStoreCoordinator = self.sourcePersistentStoreCoordinator;
    return _sourceManagedObjectContext;
}

@end

