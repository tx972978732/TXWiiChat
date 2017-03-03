//
//  WCBaseSearchController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCBaseSearchBar.h"

@interface WCBaseSearchController : UISearchController
@property(nonatomic,strong)WCBaseSearchBar *baseSearchBar;

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController searchBarFrame:(CGRect)barFrame;
@end
