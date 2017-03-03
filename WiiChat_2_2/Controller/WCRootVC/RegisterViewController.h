//
//  RegisterViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/9/23.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseViewController.h"

#define MAX_STARWORDS_LENGTH 6
@interface RegisterViewController : WCBaseViewController<UITextFieldDelegate>
-(BOOL)isValidateEmail:(NSString *)email;//邮箱合法性判断
-(BOOL)isValidatePassWord:(NSString *)password;//6-20位数字和字母组成
-(BOOL)isValidateAccount:(NSString *)account;
@end
