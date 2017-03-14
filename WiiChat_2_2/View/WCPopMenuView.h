//
//  WCPopMenuView.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCPopMenuItem.h"

typedef NSString*(^PopMenuDidSelectBlock)(NSInteger index,WCPopMenuItem *menuItem);


@interface WCPopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)PopMenuDidSelectBlock popMenuDidSelectBlock;
@property(nonatomic,copy)PopMenuDidSelectBlock popMentDismissedBlock;

- (instancetype)initWithMenus:(NSArray*)menus;
-(void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;
-(void)dismissPopMenuAnimatedOnMenuSelected:(BOOL)selected;

@end
