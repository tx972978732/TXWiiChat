//
//  WCBaseSearchViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/16.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCBaseSearchViewController : UIViewController<UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,UITableViewDelegate>
- (instancetype)initBaseSearchViewController;

@end
