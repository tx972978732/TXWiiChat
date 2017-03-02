//
//  WCSearchResultTableController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/17.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCSearchResultTableController.h"
#import "AllUsers.h"
@interface WCSearchResultTableController ()

@end
NSString *const searchResultTableVCCellIdentifier = @"searchResultTableVCCellIdentifier";

@implementation WCSearchResultTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //****点击UI切换
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSLog(@"点击搜索cell");
//}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    //return self.filteredUsers.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultTableVCCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultTableVCCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"搜索:%@",self.searchText];
    cell.imageView.image = [UIImage imageNamed:@"searchIcon2"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
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
