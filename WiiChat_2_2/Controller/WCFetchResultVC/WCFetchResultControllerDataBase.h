//
//  WCFetchResultControllerDataBase.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "WCUIStoreManager.h"
#import "Contact.h"
#import "WCContactTableViewCell.h"
@class NSFetchedResultsController;
@protocol FetchResultControllerDelegae

- (void)configureCell:(id)cell withObject:(id)object;
- (void)deleteObject:(id)object;

@end

@interface WCFetchResultControllerDataBase : NSObject<NSFetchedResultsControllerDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSFetchedResultsController *fetchResultController;
@property(nonatomic,weak)id<FetchResultControllerDelegae> delegate;
@property(nonatomic,strong)NSMutableArray *UIDataSourceArray;
@property (nonatomic) BOOL paused;
-(instancetype)initWithTableView:(UITableView*)tableView;

@end
