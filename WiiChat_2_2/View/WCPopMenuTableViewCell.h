//
//  WCPopMenuTableViewCell.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCPopMenuItem.h"

@interface WCPopMenuTableViewCell : UITableViewCell
@property(nonatomic,strong)WCPopMenuItem *menuItem;
-(void)setUpPopMenuItem:(WCPopMenuItem*)popMenuItem atIndexPath:(NSIndexPath*)indexPath isBottom:(BOOL)isBottom;
@end
