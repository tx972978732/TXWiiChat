//
//  WCSearchResultTableController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/17.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseTableViewController.h"

@interface WCSearchResultTableController : WCBaseTableViewController
@property(nonatomic,strong) NSArray *filteredUsers;
@property(nonatomic,copy) NSString *searchText;

@end
