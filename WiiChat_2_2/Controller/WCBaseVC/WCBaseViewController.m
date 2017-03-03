//
//  WCBaseViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseViewController.h"
#import "LoginViewController.h"
#import "YYEAnimatorPush.h"

@interface WCBaseViewController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)LoginViewController *loginVC;
@end

@implementation WCBaseViewController

#pragma mark - loginVC push&pop
-(void)pushLoginViewController{
    //登陆界面弹入
}
-(void)popLoginViewController:(UIViewController*)loginViewController{
    //登陆界面弹出
}
#pragma mark - public method
-(void)setUpBackgroundImage:(UIImage*)backgroundImage{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = backgroundImage;
    [self.view insertSubview:imageView atIndex:0];//视图最底层插入背景图片
}
-(void)pushNewViewController:(UIViewController*)newViewController{
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - life cycle
-(void)viewWillAppear:(BOOL)animated{
   
}
-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;{
    return YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - view rotation
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark -实现下面两个代理

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    YYEAnimatorPush *animator = [YYEAnimatorPush new];
    animator.isPresenting = YES;
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    YYEAnimatorPush *animator = [YYEAnimatorPush new];
    return animator;
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
