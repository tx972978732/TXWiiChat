//
//  WCDiscoverRootTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCDiscoverRootTableViewController.h"
#import "ODRefreshControl.h"
#import "AFNetworking.h"
@interface WCDiscoverRootTableViewController ()
@property(nonatomic,strong)ODRefreshControl *refreshController;
@end

@implementation WCDiscoverRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshController = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [self.refreshController addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"WCDiscovery-networkstatus:%@",AFStringFromNetworkReachabilityStatus(status));
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh{
    NSLog(@"refresh");
    [self.refreshController endRefreshing];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
