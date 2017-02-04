//
//  LoginViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "SmoothCheckBox.h"
#import "UserSource.h"
#import "AllUsers.h"
#import "ErrorInfo.h"

@interface LoginViewController ()
@property(nonatomic,strong)UIImageView *backgroundView;
@property(nonatomic,strong)UITextField *accountField;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)UILabel  *accountLabel;
@property(nonatomic,strong)UILabel  *passwordLabel;
@property(nonatomic,strong)UILabel  *tipLabel;
@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,strong)UIButton *forgetPwBtn;
@property(nonatomic,strong)UIBarButtonItem *backItem;
@property(nonatomic,strong)UIAlertController *errAlert;
@property(nonatomic,strong)UIAlertController *loginAlert;
@property(nonatomic,strong)UserSource *loginVCUserSource;
@end

@implementation LoginViewController

#pragma mark - life cycle
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginBackgroundImg.jpg"]];
    [self.view insertSubview:self.backgroundView atIndex:1];
    [self loadLoginTextField];
    [self loadLoginLabel];
    [self loadLoginButton];
    [self loadGesture];
    self.loginVCUserSource = [[UserSource alloc]init];
    self.backItem = [[UIBarButtonItem alloc]init];
    self.backItem.title = @"返回登录";
    self.backItem.tintColor = [UIColor brownColor];
    self.navigationItem.backBarButtonItem = self.backItem;
       // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load view
-(void)loadLoginButton{
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.commitBtn.frame = CGRectMake(139, 235, 106, 40);
    self.commitBtn.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:239.0f/255.0f blue:224.0f/255.0f alpha:1.0];
    [self.commitBtn setTitle:@"登    录" forState:UIControlStateNormal];
    self.commitBtn.layer.borderColor = [UIColor brownColor].CGColor;
    self.commitBtn.layer.borderWidth = 3.0f;
    self.commitBtn.layer.cornerRadius = 5;
    [self.commitBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.commitBtn.showsTouchWhenHighlighted = YES;
    [self.commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerBtn.frame = CGRectMake(20, 600, 96, 40);
    //self.registerBtn.backgroundColor = [UIColor lightGrayColor];
    [self.registerBtn setTitle:@"注   册" forState:UIControlStateNormal];
    //self.registerBtn.layer.borderColor = [UIColor brownColor].CGColor;
    //self.registerBtn.layer.borderWidth = 3.0f;
    //self.registerBtn.layer.cornerRadius = 5;
    [self.registerBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    self.registerBtn.showsTouchWhenHighlighted = YES;
    [self.registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    self.forgetPwBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.forgetPwBtn.frame = CGRectMake(245, 600, 96, 40);
    //self.forgetPwBtn.backgroundColor = [UIColor lightGrayColor];
    [self.forgetPwBtn setTitle:@"忘 记 密 码 ？" forState:UIControlStateNormal];
    //self.forgetPwBtn.layer.borderColor = [UIColor brownColor].CGColor;
    //self.forgetPwBtn.layer.borderWidth = 3.0f;
    //self.forgetPwBtn.layer.cornerRadius = 5;
    [self.forgetPwBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    self.forgetPwBtn.showsTouchWhenHighlighted = YES;
    [self.forgetPwBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPwBtn];
    
    
}

-(void)loadLoginLabel{
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 100, 52, 21)];
    self.accountLabel.text = @"帐号:";
    self.accountLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    self.accountLabel.textColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    self.passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 170, 52, 21)];
    self.passwordLabel.text = @"密码:";
    self.passwordLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    self.passwordLabel.textColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 59, 227, 21)];
    self.tipLabel.text = @"WiiChat帐号/邮箱帐号/手机号";
    self.tipLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    self.tipLabel.textColor = [UIColor colorWithRed:225.0f/255.0f green:226.0f/255.0f blue:227.0f/255.0f alpha:1.0];

    
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.tipLabel];
}

-(void)loadLoginTextField{
    self.accountField = [[UITextField alloc]initWithFrame:CGRectMake(70, 85, 254, 50)];
    self.accountField.borderStyle = UITextBorderStyleRoundedRect;//边框样式
    //self.accountField.textColor = [UIColor redColor];
    self.accountField.backgroundColor = [UIColor clearColor];
    self.accountField.placeholder = @"请输入用户名";
    self.accountField.alpha =1.0;
    self.accountField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.accountField.textAlignment = NSTextAlignmentLeft;
    

    self.accountField.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:205.0f/255.0f blue:181.0f/255.0f alpha:1.0].CGColor;
    self.accountField.layer.borderWidth = 3.0f;
    self.accountField.layer.cornerRadius = 5;//边框样式
    self.accountField.textColor = [UIColor darkTextColor];
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.delegate = self;
    [self.accountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.view addSubview:self.accountField];
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(70, 158, 254, 50)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.backgroundColor = [UIColor clearColor];
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.passwordField.textColor = [UIColor darkTextColor];
    self.passwordField.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:205.0f/255.0f blue:181.0f/255.0f alpha:1.0].CGColor;
    self.passwordField.layer.borderWidth = 3.0f;
    self.passwordField.layer.cornerRadius = 5;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
       tapGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - load gesture
-(void)loadGesture{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGesture];
    
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  textField.placeholder = nil;
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
        if (textField==self.accountField) {
            textField.placeholder = @"请输入用户名";
        }else if(textField==self.passwordField){
            textField.placeholder = @"请输入密码";
        }
    
    
}// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    if (textField==self.accountField) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >20) {
            return NO;
        }
    }
    return YES;
}// return NO to not change text

-(void)textFieldDidChange:(UITextField*)textField{
    if (textField==self.accountField) {
        if (textField.text.length>20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    self.checkBox.isChecked = true;
//    [self.checkBox checkBoxClicked];
    return YES;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

//[(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];//登录成功 切换根视图至主界面

    return YES;
}// called when 'return' key pressed. return NO to ignore.

#pragma mark - assisant method

-(void)viewTapped:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
#pragma mark - function button
-(void)commitBtnAction{
    NSLog(@"点击登录");
    if ([self.accountField.text isEqual:@""]) {
        [self pushErrorAlertWithInfo:@"帐号不能为空"];
    }else if ([self.passwordField.text isEqual:@""]){
        [self pushErrorAlertWithInfo:@"密码不能为空"];
    }else{
        [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
        [SVProgressHUD showWithStatus:@"正在登录中.."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                User *resultUser = [self.loginVCUserSource insertUserWithID1:self.accountField.text Password:self.passwordField.text];
            //User *resultUser = [UserSource insertUserWithID1:self.accountField.text Password:self.passwordField.text];
                //检索错误信息
                NSLog(@"登录用户信息:%@",resultUser);
                if (resultUser.wiiError!=nil) {//若有错误，输出错误信息至errorAlert
                    NSString *errorInfo = resultUser.wiiError;
                    resultUser = nil;
                    [self pushErrorAlertWithInfo:errorInfo];
                }else{          //无错误信息，转入登录流程
                    if ([resultUser.wiiLogin isEqualToString:@"YES_Pass"]) {//若未在其他设备登录，则直接登录
                        [[NSUserDefaults standardUserDefaults] setObject:resultUser.wiiID forKey:@"userID"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];//设定后下次启动自动登录
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
                        
                    }else if ([resultUser.wiiLogin isEqualToString:@"YES_AlreadyLogin"]){//若已在其他设备登录，则提示是否顶替
                        [self pushLoginAlertWithUserInfo:resultUser];
                    }
                }
                
            });
        });
    }
}

-(void)registerBtnAction{
    NSLog(@"点击注册");
    RegisterViewController *regiserVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regiserVC animated:YES];
    
}

-(void)forgetBtnAction{
    NSLog(@"点击忘记密码");
}

-(void)pushErrorAlertWithInfo:(NSString*)info{
    self.errAlert = [UIAlertController alertControllerWithTitle:info message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [self.errAlert addAction:action];
    [self presentViewController:self.errAlert animated:YES completion:nil];
}
-(void)pushLoginAlertWithUserInfo:(User*)userInfo{
    self.loginAlert = [UIAlertController alertControllerWithTitle:@"该帐号已在其他设备登录" message:@"是否顶号登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *replaceAction = [UIAlertAction actionWithTitle:@"顶号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//若选择顶号登录，则插入User查询结果至local，并完成登录
        [self.loginVCUserSource insertUser:userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo.wiiID forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];//设定后下次启动自动登录
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }];
    [self.loginAlert addAction:cancelAction];
    [self.loginAlert addAction:replaceAction];
    [self presentViewController:self.loginAlert animated:YES completion:nil];
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
