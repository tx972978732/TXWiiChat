//
//  WCProfileRootTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCProfileRootTableViewController.h"
#import "WCProfileTableViewCell.h"
#import "WCUserInfoTableViewController.h"
#import "UserSource.h"
#import "AllUsers.h"
#import "AppDelegate.h"
#import "WCUIStoreManager.h"
#import "SVProgressHUD.h"
#import "YQImageTool.h"

@interface WCProfileRootTableViewController ()
@property(nonatomic,strong)UIButton *quitBtn;
@property(nonatomic,strong)NSMutableArray *UIDataSource;
@property(nonatomic,strong)NSMutableDictionary *userInfo;
@property(nonatomic,strong)WCProfileTableViewCell *tbCell;
@property(nonatomic,strong)UserSource *profileRootVCUserSource;
@end

NSString *const profileRootTableVCHeadCellIdentifier = @"profileRootTableVCHeadCellIdentifier";
NSString *const profileRootTableVCOtherCellIdentifier = @"profileRootTableVCOtherCellIdentifier";
static BOOL shouldRefreshData = NO;//避免初始化时重复刷新tableView

@implementation WCProfileRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _userInfo = [self.profileRootVCUserSource getUserInfo];
    _UIDataSource = [[WCUIStoreManager sharedWCUIStoreManager]getProfileUIDataSource];
    [self.view addSubview:self.quitBtn];
    if (shouldRefreshData==YES) {
        shouldRefreshData = NO;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"WCProfileRootTableViewController ViewWillAppear 调用了");
    if (shouldRefreshData==NO) {
        shouldRefreshData = YES;
        return;
    }
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGSELF
        _userInfo = nil;
        _userInfo = [strongSelf.profileRootVCUserSource getUserInfo];
        [strongSelf.tableView reloadData];
        NSLog(@"WCProfileRootTableViewController ViewWillAppear reloaddata 调用了");
    });

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"WCProfileRootTableViewController ViewDidAppear 调用了");

}
-(void)dealloc{
    _profileRootVCUserSource = nil;
    _userInfo = nil;
    _UIDataSource = nil;
    _quitBtn = nil;
    _tbCell = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - load
- (UserSource*)profileRootVCUserSource{
    if (_profileRootVCUserSource) {
        return _profileRootVCUserSource;
    }
    _profileRootVCUserSource = [[UserSource alloc]init];
    return _profileRootVCUserSource;
}
-(UIButton*)quitBtn{
    if (_quitBtn) {
        return _quitBtn;
    }
    _quitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _quitBtn.frame = CGRectMake(139, 490, 106, 40);
    _quitBtn.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:239.0f/255.0f blue:224.0f/255.0f alpha:1.0];
    [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _quitBtn.layer.borderColor = [UIColor brownColor].CGColor;
    _quitBtn.layer.borderWidth = 3.0f;
    _quitBtn.layer.cornerRadius = 5;
    [_quitBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    _quitBtn.showsTouchWhenHighlighted = YES;
    [_quitBtn addTarget:self action:@selector(quitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _quitBtn;
}
#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 96;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击cell");
    if (indexPath.section==0&&indexPath.row==0) {
        WCUserInfoTableViewController  *useInfo = [[WCUserInfoTableViewController alloc]init];
        [self.navigationController pushViewController:useInfo animated:YES];
    }
}
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return [[_UIDataSource objectAtIndex:section-1]count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        WCProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileRootTableVCHeadCellIdentifier];
        if (cell==nil) {
            cell = [[WCProfileTableViewCell alloc]initHeadCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileRootTableVCHeadCellIdentifier];// coredata
        }
        if ([self.userInfo valueForKey:@"wiiHeadImg"]!=nil) {
            cell.cellImgView.image = [UIImage imageWithData:[_userInfo valueForKey:@"wiiHeadImg"]];
        }else{
            cell.cellImgView.image = [YQImageTool getThumbImageWithImage:[UIImage imageNamed:@"TestHeadImg"] andSize:CGSizeMake(50, 50) Scale:NO];
        }
        cell.cellNameLabel.text = [NSString stringWithFormat:@"%@",[_userInfo valueForKey:@"wiiName"]];
        cell.cellDetailLabel.text = [NSString stringWithFormat:@"WiiChat号: %@",[self.userInfo valueForKey:@"wiiID"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else{
        WCProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileRootTableVCOtherCellIdentifier];
        if (indexPath.section==0&&indexPath.row==1){
            if (cell==nil) {
                cell = [[WCProfileTableViewCell alloc]initOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileRootTableVCOtherCellIdentifier];
            }
            cell.cellImgView.image = [UIImage imageNamed:@"AppleWatch"];
            cell.cellNameLabel.text = @"Watch 微信";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section==3&&indexPath.row==0){
            if (cell==nil) {
                cell = [[WCProfileTableViewCell alloc]initOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileRootTableVCOtherCellIdentifier];
            }
            cell.cellImgView.image = [UIImage imageNamed:[[[_UIDataSource objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] valueForKey:@"image"]];
            cell.cellNameLabel.text = [NSString stringWithFormat:@"%@",[[[_UIDataSource objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] valueForKey:@"title"]];
            cell.cellDetailLabel.text = @"帐号未保护";//*****添加帐号保护后消除这段
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            if (cell==nil) {
                cell = [[WCProfileTableViewCell alloc]initOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileRootTableVCOtherCellIdentifier];
            }
            cell.cellImgView.image = [UIImage imageNamed:[[[_UIDataSource objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] valueForKey:@"image"]];
            cell.cellNameLabel.text = [NSString stringWithFormat:@"%@",[[[_UIDataSource objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] valueForKey:@"title"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}



-(void)quitBtnAction{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
   // [AllUsers resignUserInDataBaseWithID:[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]];
    NSString *quitResult = [self.profileRootVCUserSource resignUser1];
    NSLog(@"%@",quitResult);
    if ([quitResult isEqualToString:@"已注销用户"]||[quitResult isEqualToString:@"数据异常，强制退出登录"]) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userID"];
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }else{
        [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }
    
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
