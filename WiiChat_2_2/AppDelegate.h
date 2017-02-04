//
//  AppDelegate.h
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

//- (void)saveContext;
-(void)switchRootViewController;

@end

