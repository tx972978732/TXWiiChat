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
@property (strong, nonatomic) UIView *navLineV;

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

    //*导航栏与VC的分界线
//    //藏旧
//   [self hideBorderInView:self.navigationBar];
//    //添新
//    if (!_navLineV) {
//        _navLineV = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 1.0/ [UIScreen mainScreen].scale)];
//        _navLineV.backgroundColor = [UIColor lightGrayColor];
//        [self.navigationBar addSubview:_navLineV];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideBorderInView:(UIView *)view{
    
    
    if ([view isKindOfClass:[UIImageView class]]
        && view.frame.size.height <= 1) {
        view.hidden = YES;
    }
    for (UIView *subView in view.subviews) {
        [self hideBorderInView:subView];
    }
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
