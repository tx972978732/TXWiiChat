//
//  WCMessageRootTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCMessageRootTableViewController.h"
#import "WCContactRootTableViewController.h"
#import "ODRefreshControl.h"
#import <Masonry/Masonry.h>

@interface WCMessageRootTableViewController ()
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)ODRefreshControl *refreshController;
@end

@implementation WCMessageRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0,80, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(test)];
    _refreshController = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    _refreshController.tintColor = [UIColor lightGrayColor];
    [_refreshController addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchResultsUpdating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

-(void)test{
    WCContactRootTableViewController *testVC = [[WCContactRootTableViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}

-(void)refresh{
    NSLog(@"刷新界面");
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
        [self.refreshController endRefreshing];
    });
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
