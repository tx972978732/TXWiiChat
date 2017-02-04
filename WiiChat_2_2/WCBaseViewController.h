//
//  WCBaseViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


#import <UIKit/UIKit.h>

@interface WCBaseViewController : UIViewController<UITextFieldDelegate>
//登陆界面收发
-(void)pushLoginViewController;
-(void)popLoginViewController:(UIViewController*)loginViewController;

//public method
-(void)setUpBackgroundImage:(UIImage*)backgroundImage;
-(void)pushNewViewController:(UIViewController*)newViewController;

@end
