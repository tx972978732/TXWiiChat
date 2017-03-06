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
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "masonry.h"


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
@property(nonatomic,strong)RACSignal *validAccount;
@property(nonatomic,strong)RACSignal *validPassword;
@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginBackgroundImg"]];
    [self.view insertSubview:self.backgroundView atIndex:1];//背景图
    self.navigationItem.backBarButtonItem = self.backItem;//返回按钮
    [self loadLoginTextField];
    [self loadLoginLabel];
    [self loadLoginButton];
    [self loadGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _validAccount = nil;
    _validPassword = nil;
}

#pragma mark - load view and usersource
- (void)loadLoginButton{
    self.commitBtn.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"commitBtn was pressed!");
        [self commitBtnAction];
        return [RACSignal empty];
    }];
    //合并帐号密码字符信号，当字符均合法时，打开commitBtn使能开关，调整btn的UI显示
    @weakify(self);
    [[RACSignal combineLatest:@[_validAccount,_validPassword] reduce:^id(NSString *accountText,NSString *passwordText){
        return @(accountText.length>=1&&passwordText.length>=6  );
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.commitBtn.enabled = [x boolValue];
        switch ([x boolValue]) {
            case YES:
                self.commitBtn.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:239.0f/255.0f blue:224.0f/255.0f alpha:1.0];
                break;
            default:
                self.commitBtn.backgroundColor = [UIColor lightGrayColor];
                break;
        }
        NSLog(@"combine result:%@",x);
    }];
    [self registerBtn];
    [self forgetPwBtn];
    
    //[self.commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadLoginTextField{
    _validAccount = self.accountField.rac_textSignal;
    _validPassword = self.passwordField.rac_textSignal;
    //字符串截取，保证最常输入字符不超过20
    [_validAccount subscribeNext:^(id x) {
        NSString *tempString = [NSString stringWithFormat:@"%@",x];
        if (tempString.length>20) {
            self.accountField.text = [tempString substringToIndex:20];
        }
    }];
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.passwordField];
}

- (void)loadLoginLabel{
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.tipLabel];
}

- (UIButton*)commitBtn{
    if (_commitBtn) {
        return _commitBtn;
    }
    _commitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_commitBtn setTitle:@"登    录" forState:UIControlStateNormal];
    _commitBtn.layer.borderColor = [UIColor brownColor].CGColor;
    _commitBtn.layer.borderWidth = 3.0f;
    _commitBtn.layer.cornerRadius = 5;
    [_commitBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    _commitBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:_commitBtn];
   // _commitBtn.frame = CGRectMake(139, 235, 106, 40);
    
    _commitBtn.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:239.0f/255.0f blue:224.0f/255.0f alpha:1.0];
    [_commitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(139);
        make.top.equalTo(self.view).with.offset(235);
        make.width.equalTo(106);
        make.height.equalTo(40);
    }];
    
    return _commitBtn;
}

- (UIButton*)registerBtn{
    if (_registerBtn) {
        return _registerBtn;
    }
    _registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_registerBtn setTitle:@"注   册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    _registerBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:_registerBtn];
    [_registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];

   // _registerBtn.frame = CGRectMake(20, 600, 96, 40);
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(600);
        make.width.equalTo(96);
        make.height.equalTo(40);
    }];
    return _registerBtn;
}

- (UIButton*)forgetPwBtn{
    if (_forgetPwBtn) {
        return _forgetPwBtn;
    }
    _forgetPwBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_forgetPwBtn setTitle:@"忘 记 密 码 ？" forState:UIControlStateNormal];
    [_forgetPwBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    _forgetPwBtn.showsTouchWhenHighlighted = YES;
    [_forgetPwBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwBtn];
   // _forgetPwBtn.frame = CGRectMake(245, 600, 96, 40);
    [_forgetPwBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerBtn).with.offset(225);
        make.top.equalTo(self.registerBtn);
        make.width.equalTo(96);
        make.height.equalTo(40);
    }];
    return _forgetPwBtn;
}


- (UILabel*)accountLabel{
    if (_accountLabel) {
        return _accountLabel;
    }
    _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 100, 52, 21)];
    _accountLabel.text = @"帐号:";
    _accountLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _accountLabel.textColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    return _accountLabel;
}

- (UILabel*)passwordLabel{
    if (_passwordLabel) {
        return _passwordLabel;
    }
    _passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 170, 52, 21)];
    _passwordLabel.text = @"密码:";
    _passwordLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _passwordLabel.textColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    return _passwordLabel;
}

- (UILabel*)tipLabel{
    if (_tipLabel) {
        return _tipLabel;
    }
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 59, 227, 21)];
    _tipLabel.text = @"WiiChat帐号/邮箱帐号/手机号";
    _tipLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    _tipLabel.textColor = [UIColor colorWithRed:225.0f/255.0f green:226.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    return _tipLabel;
}


- (UITextField*)accountField{
    if (_accountField) {
        return _accountField;
    }
    _accountField = [[UITextField alloc]initWithFrame:CGRectMake(70, 85, 254, 50)];
    _accountField.borderStyle = UITextBorderStyleRoundedRect;//边框样式
    _accountField.backgroundColor = [UIColor clearColor];
    _accountField.placeholder = @"请输入用户名";
    _accountField.alpha =1.0;
    _accountField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    _accountField.textAlignment = NSTextAlignmentLeft;
    _accountField.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:205.0f/255.0f blue:181.0f/255.0f alpha:1.0].CGColor;
    _accountField.layer.borderWidth = 3.0f;
    _accountField.layer.cornerRadius = 5;//边框样式
    _accountField.textColor = [UIColor darkTextColor];
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.delegate = self;
    return _accountField;
}

- (UITextField*)passwordField{
    if (_passwordField) {
        return _passwordField;
    }
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(70, 158, 254, 50)];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.backgroundColor = [UIColor clearColor];
    _passwordField.placeholder = @"请输入密码";
    _passwordField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    _passwordField.textColor = [UIColor darkTextColor];
    _passwordField.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:205.0f/255.0f blue:181.0f/255.0f alpha:1.0].CGColor;
    _passwordField.layer.borderWidth = 3.0f;
    _passwordField.layer.cornerRadius = 5;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    return _passwordField;
}

- (UIBarButtonItem*)backItem{
    if (_backItem) {
        return _backItem;
    }
    _backItem = [[UIBarButtonItem alloc]init];
    _backItem.title = @"返回登录";
    _backItem.tintColor = [UIColor brownColor];
    return _backItem;
}

- (UserSource*)loginVCUserSource{
    if (_loginVCUserSource) {
        return _loginVCUserSource;
    }
    _loginVCUserSource = [[UserSource alloc]init];
    return _loginVCUserSource;
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
        [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
        [SVProgressHUD showWithStatus:@"正在登录中.."];
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                STRONGSELF
                [SVProgressHUD dismiss];
                User *resultUser = [strongSelf.loginVCUserSource insertUserWithID1:strongSelf.accountField.text Password:strongSelf.passwordField.text];
            //User *resultUser = [UserSource insertUserWithID1:self.accountField.text Password:self.passwordField.text];
                //检索错误信息
                NSLog(@"登录用户信息:%@",resultUser);
                if (resultUser.wiiError!=nil) {//若有错误，输出错误信息至errorAlert
                    NSString *errorInfo = resultUser.wiiError;
                    resultUser = nil;
                    [strongSelf pushErrorAlertWithInfo:errorInfo];
                }else{          //无错误信息，转入登录流程
                    if ([resultUser.wiiLogin isEqualToString:@"YES_Pass"]) {//若未在其他设备登录，则直接登录
                        [[NSUserDefaults standardUserDefaults] setObject:resultUser.wiiID forKey:@"userID"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];//设定后下次启动自动登录
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
                        
                    }else if ([resultUser.wiiLogin isEqualToString:@"YES_AlreadyLogin"]){//若已在其他设备登录，则提示是否顶替
                        [strongSelf pushLoginAlertWithUserInfo:resultUser];
                    }
                }
                
            });
        });
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
