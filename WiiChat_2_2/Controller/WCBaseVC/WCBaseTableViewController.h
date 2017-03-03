//
//  WCBaseTableViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseViewController.h"
#import "ErrorInfo.h"

@interface WCBaseTableViewController : UITableViewController
//@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableViewCell *tableViewCell;
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
