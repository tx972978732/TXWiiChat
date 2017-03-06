//
//  RegisterViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/9/23.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "RegisterViewController.h"
#import "SmoothCheckBox.h"
#import "RegisterHelper.h"

@interface RegisterViewController ()
@property(nonatomic,strong)UIImageView *backgroundView;
@property(nonatomic,strong)UITextField *accountField;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)UITextField *checkPasswordField;
@property(nonatomic,strong)UITextField *emailField;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)UILabel *checkPasswordLabel;
@property(nonatomic,strong)UILabel *emailLabel;
@property(nonatomic,strong)SmoothCheckBox *accountCheckBox;
@property(nonatomic,strong)SmoothCheckBox *passwordCheckBox;
@property(nonatomic,strong)SmoothCheckBox *checkPasswordCheckBox;
@property(nonatomic,strong)SmoothCheckBox *emailCheckBox;
@property(nonatomic,strong)UIButton *commitButton;
@property(nonatomic,copy)NSMutableArray *checkBoxArray;
@property(nonatomic,strong)UIAlertController *accountAlert;
@property(nonatomic,strong)UIAlertController *passwordAlert;
@property(nonatomic,strong)UIAlertController *checkPasswordAlert;
@property(nonatomic,strong)UIAlertController *emailAlert;
@property(nonatomic,strong)NSMutableDictionary *registerDic;
@end

@implementation RegisterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerDic = [NSMutableDictionary dictionary];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginBackgroundImg"]];
    [self.view insertSubview:self.backgroundView atIndex:1];
    [self loadRegisterTextField];
    [self loadRegisterLabel];
    [self loadGesture];
    [self loadCheckBox];
    [self loadButton];
    
    
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load view
-(void)loadRegisterTextField{
    self.accountField = [[UITextField alloc]initWithFrame:CGRectMake(90, 85, 254, 50)];
    self.accountField.borderStyle = UITextBorderStyleRoundedRect;
    //self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.accountField.placeholder = @"请输入用户名";
    self.accountField.textColor = [UIColor darkTextColor];
    self.accountField.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:100.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;
    self.accountField.layer.borderWidth = 3.0f;
    self.accountField.layer.cornerRadius = 5.0f;
    self.accountField.backgroundColor = [UIColor whiteColor];
    self.accountField.tag = 0;
    self.accountField.textContentType = UITextContentTypeNickname;
    self.accountField.delegate = self;
    [self.view addSubview:self.accountField];
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(90, 175, 254, 50)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
   // self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //self.passwordField.clearsOnBeginEditing = YES;
    self.passwordField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.passwordField.placeholder = @"6-20位数字和字母组成";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textColor = [UIColor darkTextColor];
    self.passwordField.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:100.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;    self.passwordField.layer.borderWidth = 3.0f;
    self.passwordField.layer.cornerRadius = 5.0f;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.tag = 1;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    
    self.checkPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(90, 265, 254, 50)];
    self.checkPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    //self.checkPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //self.checkPasswordField.clearsOnBeginEditing = YES;
    self.checkPasswordField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.checkPasswordField.placeholder = @"请再次输入密码";
    self.checkPasswordField.secureTextEntry = YES;
    self.checkPasswordField.textColor = [UIColor darkTextColor];
    self.checkPasswordField.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:100.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;
    self.checkPasswordField.layer.borderWidth = 3.0f;
    self.checkPasswordField.layer.cornerRadius = 5.0f;
    self.checkPasswordField.backgroundColor = [UIColor whiteColor];
    self.checkPasswordField.tag = 2;
    self.checkPasswordField.delegate = self;
    [self.view addSubview:self.checkPasswordField];
    
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(90, 355, 254, 50)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    //self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.emailField.placeholder = @"请输入邮箱地址";
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.textColor = [UIColor darkTextColor];
    self.emailField.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:100.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;
    self.emailField.layer.borderWidth = 3.0f;
    self.emailField.layer.cornerRadius = 5.0f;
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.tag = 3;
    self.emailField.delegate = self;
    [self.view addSubview:self.emailField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.accountField];
    
}

-(void)loadRegisterLabel{
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 100, 88, 21)];
    self.accountLabel.text = @"用 户 名:";
    self.accountLabel.textColor = [UIColor darkTextColor];
    self.accountLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self.view addSubview:self.accountLabel];
    
    self.passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 190, 88, 21)];
    self.passwordLabel.text = @"密     码:";
    self.passwordLabel.textColor = [UIColor darkTextColor];
    self.passwordLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self.view addSubview:self.passwordLabel];
    
    self.checkPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 280, 88, 21)];
    self.checkPasswordLabel.text = @"重复密码:";
    self.checkPasswordLabel.textColor = [UIColor darkTextColor];
    self.checkPasswordLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self.view addSubview:self.checkPasswordLabel];
    
    self.emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 370, 88, 21)];
    self.emailLabel.text = @"邮箱帐号:";
    self.emailLabel.textColor = [UIColor darkTextColor];
    self.emailLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self.view addSubview:self.emailLabel];
    
}

-(void)loadCheckBox{
    self.accountCheckBox = [[SmoothCheckBox alloc] initWithSideWidth:20];
    self.accountCheckBox.center = CGPointMake(359, 110);
    self.accountCheckBox.uncheckedFillColor = [UIColor clearColor];
    self.accountCheckBox.backgroundColor = [UIColor clearColor];
    self.accountCheckBox.uncheckedBorderColor = [UIColor clearColor];
    self.accountCheckBox.tag = 0;
    [self.view addSubview:self.accountCheckBox];
    
    self.passwordCheckBox = [[SmoothCheckBox alloc] initWithSideWidth:20];
    self.passwordCheckBox.center = CGPointMake(359, 200);
    self.passwordCheckBox.uncheckedFillColor = [UIColor clearColor];
    self.passwordCheckBox.backgroundColor = [UIColor clearColor];
    self.passwordCheckBox.uncheckedBorderColor = [UIColor clearColor];
    self.passwordCheckBox.tag = 1;
    [self.view addSubview:self.passwordCheckBox];
    
    self.checkPasswordCheckBox = [[SmoothCheckBox alloc] initWithSideWidth:20];
    self.checkPasswordCheckBox.center = CGPointMake(359, 290);
    self.checkPasswordCheckBox.uncheckedFillColor = [UIColor clearColor];
    self.checkPasswordCheckBox.backgroundColor = [UIColor clearColor];
    self.checkPasswordCheckBox.uncheckedBorderColor = [UIColor clearColor];
    self.checkPasswordCheckBox.tag = 2;
    [self.view addSubview:self.checkPasswordCheckBox];
    
    self.emailCheckBox = [[SmoothCheckBox alloc] initWithSideWidth:20];
    self.emailCheckBox.center = CGPointMake(359, 380);
    self.emailCheckBox.uncheckedFillColor = [UIColor clearColor];
    self.emailCheckBox.backgroundColor = [UIColor clearColor];
    self.emailCheckBox.uncheckedBorderColor = [UIColor clearColor];
    self.emailCheckBox.tag = 3;
    [self.view addSubview:self.emailCheckBox];
    
    self.checkBoxArray = [NSMutableArray arrayWithObjects:self.accountCheckBox,self.passwordCheckBox,self.checkPasswordCheckBox,self.emailCheckBox, nil];
}

-(void)loadButton{
    self.commitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.commitButton.frame = CGRectMake(156, 425, 88, 40);
    self.commitButton.backgroundColor = [UIColor clearColor];
    self.commitButton.layer.borderColor = [UIColor colorWithRed:253.0f/255.0f green:210.0f/255.0f blue:71.0f/255.0f alpha:1.0].CGColor;
    self.commitButton.layer.borderWidth = 3;
    [self.commitButton setTitle:@"提   交" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitButton.showsTouchWhenHighlighted = YES;
    [self.commitButton addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.commitButton];
}

#pragma mark - load guesture
-(void)loadGesture{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGesture];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewSwipe:)];
    swipeGestureUp.cancelsTouchesInView = NO;
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewSwipe:)];
    swipeGestureDown.cancelsTouchesInView = NO;
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureDown];

}



#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;{
    textField.placeholder = nil;
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;{
    
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    //此处应访问数据库方法通过回调确认 true or false
    switch(textField.tag){
            case 0:
            textField.placeholder = @"请输入用户名";
            if(![textField.text isEqual:@""]){
                if ([self isValidateAccount:textField.text]&&textField.text.length<=8) {  //判断条件 应该由数据库回调确定
                self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.accountCheckBox checkBoxClicked];
                self.accountCheckBox.isChecked = false;
                [self.accountCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                [self.accountCheckBox checkBoxClicked];
            }else{
                self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.accountCheckBox checkBoxClicked];
                self.accountCheckBox.isChecked = false;
                [self.accountCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                [self.accountCheckBox checkBoxClicked];
            }}
            else{
                self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.accountCheckBox checkBoxClicked];
            }

            break;
            case 1:
            textField.placeholder = @"6-20位数字和字母组成";
            if(![textField.text isEqual:@""]){
            if ([self isValidatePassWord:textField.text]) {
                self.passwordCheckBox.isChecked = false;
                [self.passwordCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                [self.passwordCheckBox checkBoxClicked];
            }else{
                self.passwordCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.passwordCheckBox checkBoxClicked];
                self.passwordCheckBox.isChecked = false;
                [self.passwordCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                [self.passwordCheckBox checkBoxClicked];
            }}
            else{
                self.passwordCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.passwordCheckBox checkBoxClicked];
            }
            break;
            case 2:
            textField.placeholder = @"请再次输入密码";
            if(![textField.text isEqual:@""]){
                if ([textField.text isEqualToString:self.passwordField.text]&&[self isValidatePassWord:self.passwordField.text]) {
                self.checkPasswordCheckBox.isChecked = false;
                [self.checkPasswordCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                [self.checkPasswordCheckBox checkBoxClicked];
                    }else{
                        self.checkPasswordCheckBox.isChecked = true;
                        [self.checkPasswordCheckBox checkBoxClicked];//清除内容时 清除checkbox动画
                        self.checkPasswordCheckBox.isChecked = false;
                        [self.checkPasswordCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                        [self.checkPasswordCheckBox checkBoxClicked];
                            }
                        }
            else{
                self.checkPasswordCheckBox.isChecked = true;
                [self.checkPasswordCheckBox checkBoxClicked];//清除内容时 清除checkbox动画

            }
            break;
            case 3:
            if(![textField.text isEqual:@""]){
                if ([self isValidateEmail:textField.text]) {//检查邮箱名是否合法
                    if (![[RegisterHelper sharedRegisterHelper]isEmailRegistered:textField.text]) {//检查邮箱是否已被注册
                        self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                        [self.emailCheckBox checkBoxClicked];
                        self.emailCheckBox.isChecked = false;
                        [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                        [self.emailCheckBox checkBoxClicked];
                    }else{
                        self.emailAlert = [UIAlertController alertControllerWithTitle:@"该邮箱已被注册！" message:@"请使用其他邮箱注册" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.emailField.text = nil;
                        }];
                        [self.emailAlert addAction:action];
                        [self presentViewController:self.emailAlert animated:YES completion:nil];//提示已被注册
                        self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                        [self.emailCheckBox checkBoxClicked];
                        self.emailCheckBox.isChecked = false;
                        [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                        [self.emailCheckBox checkBoxClicked];
                    }
                }else{
                    self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.emailCheckBox checkBoxClicked];
                    self.emailCheckBox.isChecked = false;
                    [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                    [self.emailCheckBox checkBoxClicked];
                }}
            else{
                self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.emailCheckBox checkBoxClicked];
            }
            break;
            default:
            NSLog(@"textField.placeholder error");
            break;
    }
    
}// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (string.length==0) {
                    return YES;
                }
    switch (textField.tag) {
        case 0:
        {
            self.accountCheckBox.isChecked = true;
            [self.accountCheckBox checkBoxClicked];

        }
            break;
        case 1:
        {   self.passwordCheckBox.isChecked = true;
            [self.passwordCheckBox checkBoxClicked];
            self.checkPasswordCheckBox.isChecked = true;
            [self.checkPasswordCheckBox checkBoxClicked];
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength >16) {
                return NO;
            }
        }
            break;
        case 2:
        {    self.checkPasswordCheckBox.isChecked = true;
            [self.checkPasswordCheckBox checkBoxClicked];
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength >16) {
                return NO;
            }
        }
            break;
        case 3:
        {    self.emailCheckBox.isChecked = true;
            [self.emailCheckBox checkBoxClicked];
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength >30) {
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    switch (textField.tag) {
//        case 0:
//            self.accountCheckBox.isChecked = true;
//            [self.accountCheckBox checkBoxClicked];
//            break;
//        case 1:
//            self.passwordCheckBox.isChecked = true;
//            [self.passwordCheckBox checkBoxClicked];
//            
//            break;
//        case 2:
//            self.checkPasswordCheckBox.isChecked = true;
//            [self.checkPasswordCheckBox checkBoxClicked];
//            break;
//        case 3:
//            self.emailCheckBox.isChecked = true;
//            [self.emailCheckBox checkBoxClicked];
//            break;
//        default:
//            break;
//    }
    return YES;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    //[textField resignFirstResponder];
    switch(textField.tag){
        case 0:
            if(![textField.text isEqual:@""]){
                if ([self isValidateAccount:textField.text]&&textField.text.length<=8) {  //判断条件 应该由数据库回调确定
                    self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.accountCheckBox checkBoxClicked];
                    self.accountCheckBox.isChecked = false;
                    [self.accountCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                    [self.accountCheckBox checkBoxClicked];
                }else{
                    self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.accountCheckBox checkBoxClicked];
                    self.accountCheckBox.isChecked = false;
                    [self.accountCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                    [self.accountCheckBox checkBoxClicked];
                }}
            else{
                    self.accountCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.accountCheckBox checkBoxClicked];
                }
            
            break;
        case 1:
            if(![textField.text isEqual:@""]){
                if ([self isValidatePassWord:textField.text]) {
                    self.passwordCheckBox.isChecked = false;
                    [self.passwordCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                    [self.passwordCheckBox checkBoxClicked];
                }else{
                    self.passwordCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.passwordCheckBox checkBoxClicked];
                    self.passwordCheckBox.isChecked = false;
                    [self.passwordCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                    [self.passwordCheckBox checkBoxClicked];
                }}
            break;
        case 2:
                if(![textField.text isEqual:@""]){
                if ([textField.text isEqualToString:self.passwordField.text]&&[self isValidatePassWord:self.passwordField.text]) {
                    self.checkPasswordCheckBox.isChecked = false;
                    [self.checkPasswordCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                    [self.checkPasswordCheckBox checkBoxClicked];
                }else{
                    self.checkPasswordCheckBox.isChecked = true;
                    [self.checkPasswordCheckBox checkBoxClicked];//清除内容时 清除checkbox动画
                    self.checkPasswordCheckBox.isChecked = false;
                    [self.checkPasswordCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                    [self.checkPasswordCheckBox checkBoxClicked];
                }
            }
            break;
        case 3:
            if(![textField.text isEqual:@""]){
                if ([self isValidateEmail:textField.text]) {//检查邮箱名是否合法
                    if (![[RegisterHelper sharedRegisterHelper]isEmailRegistered:textField.text]) {//检查邮箱是否已被注册
                        self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                        [self.emailCheckBox checkBoxClicked];
                        self.emailCheckBox.isChecked = false;
                        [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleTick];
                        [self.emailCheckBox checkBoxClicked];
                    }else{
                        self.emailAlert = [UIAlertController alertControllerWithTitle:@"该邮箱已被注册！" message:@"请使用其他邮箱注册" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.emailField.text = nil;
                        }];
                        [self.emailAlert addAction:action];
                        [self presentViewController:self.emailAlert animated:YES completion:nil];//提示已被注册
                        self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                        [self.emailCheckBox checkBoxClicked];
                        self.emailCheckBox.isChecked = false;
                        [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                        [self.emailCheckBox checkBoxClicked];
                    }
                }else{
                    self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                    [self.emailCheckBox checkBoxClicked];
                    self.emailCheckBox.isChecked = false;
                    [self.emailCheckBox setCheckBoxStyle:CheckBoxStyleClose];
                    [self.emailCheckBox checkBoxClicked];
                }}
            else{
                self.emailCheckBox.isChecked = true;//清除内容时 清除checkbox动画
                [self.emailCheckBox checkBoxClicked];
            }
            break;
        default:

            break;
    }

    return YES;
}// called when 'return' key pressed. return NO to ignore.



#pragma assistant method
-(void)viewTapped:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
   // [self.accountField resignFirstResponder];
}
-(void)viewSwipe:(UISwipeGestureRecognizer*)swipe{
    [self.view endEditing:YES];
}

-(void)textFieldEditChanged:(NSNotification*)obj{
       UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制 优化第三方输入法
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(BOOL)isValidatePassWord:(NSString *)password
{
    //6-20位数字和字母组成
    NSString *passwordregex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordregex];
    return [pred evaluateWithObject:password];
    
}
-(BOOL)isValidateAccount:(NSString *)account{
    NSString *accountRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountRegex];
    return [pred evaluateWithObject:account];}


-(void)commitBtnAction{
    if ([self.accountField.text isEqual:@""]) {
        self.accountAlert = [UIAlertController alertControllerWithTitle:@"用户名不能为空" message:@"请输入6位以下中英文字符" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [self.accountAlert addAction:cancelAction];
        [self presentViewController:self.accountAlert animated:YES completion:nil];
        return;
    }else if ([self.passwordField.text isEqual:@""]){
        self.passwordAlert = [UIAlertController alertControllerWithTitle:@"密码不能为空" message:@"请输入6位以下中英文字符" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [self.passwordAlert addAction:cancelAction];
        [self presentViewController:self.passwordAlert animated:YES completion:nil];
        return;
    }else if ([self.checkPasswordField.text isEqual:@""]){
        self.checkPasswordAlert = [UIAlertController alertControllerWithTitle:@"请再次输入密码" message:@"两次输入密码不同" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [self.checkPasswordAlert addAction:cancelAction];
        [self presentViewController:self.checkPasswordAlert animated:YES completion:nil];
        return;
    }else if ([self.emailField.text isEqual:@""]){
        self.emailAlert = [UIAlertController alertControllerWithTitle:@"邮箱不能为空" message:@"请输入你的邮箱" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [self.emailAlert addAction:cancelAction];
        [self presentViewController:self.emailAlert animated:YES completion:nil];
        return;
    }
    if (self.accountCheckBox.checkBoxStyle==CheckBoxStyleClose) {
        self.accountAlert = [UIAlertController alertControllerWithTitle:@"用户名错误" message:@"请输入6位以下中英文字符" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [self.accountAlert addAction:cancelAction];
        [self presentViewController:self.accountAlert animated:YES completion:nil];
        return;
    }
    if (self.passwordCheckBox.checkBoxStyle==CheckBoxStyleClose) {
        UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"密码错误" message:@"请输入6～20位数字和字母组合" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [passwordAlert addAction:cancelAction];
        [self presentViewController:passwordAlert animated:YES completion:nil];
        return;
    }
    if (self.checkPasswordCheckBox.checkBoxStyle==CheckBoxStyleClose) {
        UIAlertController *checkPasswordAlert = [UIAlertController alertControllerWithTitle:@"重复密码错误" message:@"两次输入密码不同" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [checkPasswordAlert addAction:cancelAction];
        [self presentViewController:checkPasswordAlert animated:YES completion:nil];
        return;
    }
    if (self.emailCheckBox.checkBoxStyle==CheckBoxStyleClose) {
        UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"邮箱名错误" message:@"邮箱名不合法" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [emailAlert addAction:cancelAction];
        [self presentViewController:emailAlert animated:YES completion:nil];
        return;
    }
    
    NSLog(@"提交");
    [self registerDone];
}
-(void)registerDone{
    //注册并返回帐号
    [self saveRegisterInfo];
    NSString *newUserID =  [[RegisterHelper sharedRegisterHelper] registerUserWithInfo:self.registerDic];
    //Alert提示新帐号信息
    UIAlertController * registerDoneAlert = [UIAlertController alertControllerWithTitle:@"恭喜您成功创建WiiChat帐号" message:[NSString stringWithFormat:@"您的WiiChat帐号为:%@",newUserID] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loadAction = [UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [registerDoneAlert addAction:loadAction];
    [registerDoneAlert addAction:cancelAction];
    [self presentViewController:registerDoneAlert animated:YES completion:nil];
}

-(void)saveRegisterInfo{
    [self.registerDic setValue:self.accountField.text forKey:@"name"];
    [self.registerDic setValue:self.passwordField.text forKey:@"password"];
    [self.registerDic setValue:self.emailField.text forKey:@"email"];
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
