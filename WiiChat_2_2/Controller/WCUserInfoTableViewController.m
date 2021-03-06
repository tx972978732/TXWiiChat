//
//  WCUserInfoTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/9.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCUserInfoTableViewController.h"
#import "WCEditUserInfoTableViewController.h"
#import "WCBaseNavigationController.h"
#import "WCProfileTableViewCell.h"
#import "UserSource.h"
#import "YQImageTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WCUserInfoTableViewController ()
@property(nonatomic,strong)NSMutableDictionary *userInfo;
@property(nonatomic,strong)UserSource *UserInfoVCUserSource;
@end

NSString *const userInfoTableVCCellIdentifier = @"userInfoTableVCCellIdentifier";
static BOOL shouldRefreshData = NO;//避免初始化时重复刷新tableView
@implementation WCUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WCUserInfoTableViewController ViewDidLoad 调用了");
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.title = @"个人信息";
    _userInfo = [self.UserInfoVCUserSource getUserInfo];
    if (shouldRefreshData==YES) {
        shouldRefreshData = NO;
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"WCUserInfoTableViewController ViewWillAppear 调用了");
    if (shouldRefreshData==NO) {
        shouldRefreshData = YES;
        return;
    }
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGSELF
        _userInfo = nil;
        _userInfo = [strongSelf.UserInfoVCUserSource getUserInfo];
        [strongSelf.tableView reloadData];
        
    });
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"WCUserInfoTableViewController ViewDidAppear 调用了");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"WCUserInfoTableViewController delloc");
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    _userInfo = nil;
    _UserInfoVCUserSource = nil;
    shouldRefreshData = NO;
}
#pragma mark - load
- (UserSource*)UserInfoVCUserSource{
    if (_UserInfoVCUserSource) {
        return _UserInfoVCUserSource;
    }
    _UserInfoVCUserSource = [[UserSource alloc]init];
    return _UserInfoVCUserSource;
}
#pragma mark -UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 90;
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
    //NSLog(@"点击cell");
    if (indexPath.section==0&&indexPath.row==1) {
        WCEditUserInfoTableViewController *editNameVC = [[WCEditUserInfoTableViewController alloc]initWithUserInfoEditType:userInfoEditTypeName userInfo:self.userInfo];
        [self.navigationController pushViewController:editNameVC animated:YES];
    }else if (indexPath.section==1&&indexPath.row==0){
        WCEditUserInfoTableViewController *editGenderVC = [[WCEditUserInfoTableViewController alloc]initWithUserInfoEditType:userInfoEditTypeSex userInfo:self.userInfo];
        [self.navigationController pushViewController:editGenderVC animated:YES];
    }else if (indexPath.section==1&&indexPath.row==2){
        WCEditUserInfoTableViewController *editSignatureVC = [[WCEditUserInfoTableViewController alloc]initWithUserInfoEditType:userInfoEditTypeSignature userInfo:self.userInfo];
        [self.navigationController pushViewController:editSignatureVC animated:YES];
    }else if (indexPath.section==0&&indexPath.row==0){
        WCEditUserInfoTableViewController *editHeadImgVC = [[WCEditUserInfoTableViewController alloc]initWithUserInfoEditType:userInfoEditTypeHeadImg userInfo:self.userInfo];
        [self.navigationController pushViewController:editHeadImgVC animated:YES];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        WCProfileTableViewCell *headTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoHeadCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];// CoreData
        if ([self.userInfo valueForKey:@"wiiHeadImg"]!=nil) {
            headTableViewCell.cellImgView.image = [UIImage imageWithData:[self.userInfo valueForKey:@"wiiHeadImg"]];
        }else{
            NSURL *url = [NSURL URLWithString:@"https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM859/en_US/sierra-roundel-240.png"];
            [headTableViewCell.cellImgView setShowActivityIndicatorView:YES];
            [headTableViewCell.cellImgView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [headTableViewCell.cellImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"LoginBackgroundImg"]];
        }
        headTableViewCell.cellNameLabel.text = @"头像";
        headTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return headTableViewCell;
    }else if (indexPath.section==0&&indexPath.row==1){
        WCProfileTableViewCell *nameTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        nameTableViewCell.cellNameLabel.text = @"名字";
        nameTableViewCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"wiiName"]];
        nameTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return nameTableViewCell;
    }else if (indexPath.section==0&&indexPath.row==2){
        WCProfileTableViewCell *IDTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        IDTableViewCell.cellNameLabel.text = @"WiiChat帐号";
        IDTableViewCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"wiiID"]];
        return IDTableViewCell;
    }else if (indexPath.section==0&&indexPath.row==3){
        WCProfileTableViewCell *QRCodeTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        QRCodeTableViewCell.cellNameLabel.text = @"我的二维码";
        QRCodeTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //***************** 后续增加二维码
        return QRCodeTableViewCell;
    }else if (indexPath.section==0&&indexPath.row==4){
        WCProfileTableViewCell *addressTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        addressTableViewCell.cellNameLabel.text = @"我的地址";
        addressTableViewCell.cellDetailLabel.text = [self.userInfo valueForKey:@"wiiAddress"];
        //addressTableViewCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",self.userInfo.wiiAddress];
        addressTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return addressTableViewCell;
    }else if (indexPath.section==1&&indexPath.row==0){
        WCProfileTableViewCell *sexTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        sexTableViewCell.cellNameLabel.text = @"性别";
        sexTableViewCell.cellDetailLabel.text = [self.userInfo valueForKey:@"wiiSex"];
       // sexTableViewCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",self.userInfo.wiiSex];
        sexTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return sexTableViewCell;
    }else if (indexPath.section==1&&indexPath.row==1){
        WCProfileTableViewCell *localTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        localTableViewCell.cellNameLabel.text = @"地区";
        localTableViewCell.cellDetailLabel.text = @"中国 重庆";//**************** 增加定位功能
        localTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return localTableViewCell;
    }else{
        WCProfileTableViewCell *signatureTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoOtherCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoTableVCCellIdentifier];
        signatureTableViewCell.cellNameLabel.text = @"个性签名";
        signatureTableViewCell.cellDetailLabel.text = [self.userInfo valueForKey:@"wiiSignature"];
        //signatureTableViewCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",self.userInfo.wiiSignature];
        signatureTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return signatureTableViewCell;
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
