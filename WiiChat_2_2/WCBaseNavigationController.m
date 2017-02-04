//
//  WCBaseNavigationController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/9/23.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseNavigationController.h"
#import "UIBaseSettingInfo.h"

@interface WCBaseNavigationController ()

@end

@implementation WCBaseNavigationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = WCNavigationBarTintColor;
    self.navigationBar.tintColor = WCNavigationTintColor;
    self.navigationBar.titleTextAttributes = WCNavigationBarTitleTextAttribute;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];//push时隐藏底部bar
}


#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
