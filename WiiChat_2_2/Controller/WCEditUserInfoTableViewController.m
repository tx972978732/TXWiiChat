//
//  WCEditUserInfoTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/10.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCEditUserInfoTableViewController.h"
#import "WCProfileTableViewCell.h"
#import "SVProgressHUD.h"
#import "EditUserInfoHelper.h"
#import "CountStringLengthHelper.h"
#import "WCHeadImgScrollVIew.h"

#define MAX_STARWORDS_LENGTH 30

@interface WCEditUserInfoTableViewController ()
@property(nonatomic,strong)UITextField *editNameTextField;
@property(nonatomic,strong)UITextView *editNameTextView;
@property(nonatomic,strong)NSMutableDictionary *userInfo;
@property(nonatomic,strong)NSIndexPath *editGenderIndexPath;
@property(nonatomic,strong)UITextView *editSignatureTextView;
@property(nonatomic,strong)UILabel *editSignatureCountLabel;
@property(nonatomic,strong)UIImageView *editHeadImgView;
@property(nonatomic,strong)CountStringLengthHelper *countStringHelper;
@property(nonatomic,strong)WCHeadImgScrollVIew *headImgScrollView;
@end

NSString *const eidtUserInfoTableVCCellIdentifier = @"eidtUserInfoTableVCCellIdentifier";
static userInfoEditType editType;
static BOOL tapClicks=NO;
@implementation WCEditUserInfoTableViewController

#pragma mark - life cycle
-(instancetype)initWithUserInfoEditType:(userInfoEditType)type userInfo:(NSMutableDictionary *)userInfo{
    self = [super init];
    NSLog(@"InitWithUserInfo 调用了");
    if (self) {
        self.userInfo = userInfo;
        editType = type;
        NSLog(@"editType1:%ld",(long)editType);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"EditUserInfo ViewDidLoad调用了");
    if (editType==userInfoEditTypeHeadImg) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor blackColor];
        [self loadGesture];
    }else if (editType==userInfoEditTypeSignature){
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.editSignatureTextView];//限制字符串长度
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    switch (editType) {
        case userInfoEditTypeName:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(popEditUserVC)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveEditName)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
            self.title = @"名字";
            break;
        case userInfoEditTypeSignature:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(saveEditSignature)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
            self.title = @"个性签名";
            break;
        case userInfoEditTypeSex:
            self.title = @"性别";
            break;
        case userInfoEditTypeHeadImg:
            self.title = @"个人头像";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(choseHeadImg)];
            break;
        case userInfoEditTypeQRCode:
            self.title = @"我的二维码";
            break;
        case userInfoEditTypeAddress:
            self.title = @"我的地址";
            break;
        case userInfoEditTypeLocal:
            self.title = @"地区";
            break;
        default:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(popEditUserVC)];
            break;
    }
    NSLog(@"editType2:%ld",(long)editType);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _editNameTextField.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    _headImgScrollView.delegate = nil;
    _headImgScrollView = nil;
    _editNameTextField = nil;
    _userInfo = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"  object:self.editSignatureTextView];
    NSLog(@"WCEditUserTableViewController dealloc");
}
#pragma mark - load
- (UIScrollView*)headImgScrollView{
    if (_headImgScrollView) {
        return _headImgScrollView;
    }
    _headImgScrollView = [[WCHeadImgScrollVIew alloc]initHeadImgScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 810) ViewType:headImgScrollViewTypeDefault headImg:[UIImage imageNamed:@"TestHeadImg.jpg"]];
    _headImgScrollView.delegate = self;
    self.tableView.scrollEnabled = NO;
    _headImgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 800);
    _headImgScrollView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    return _headImgScrollView;
}
-(UITextView*)editSignatureTextView{
    if (_editSignatureTextView) {
        return _editSignatureTextView;
    }
    _editSignatureTextView = [[UITextView alloc]init];
    return _editSignatureTextView;
}

- (UITextField*)editNameTextField{
    if (_editNameTextField) {
        return _editNameTextField;
    }
    _editNameTextField = [[UITextField alloc]init];
    return _editNameTextField;
}

- (CountStringLengthHelper*)countStringHelper{
    if (_countStringHelper) {
        return _countStringHelper;
    }
    _countStringHelper = [[CountStringLengthHelper alloc]initCountHelperWithMAX_Length:MAX_STARWORDS_LENGTH];
    return _countStringHelper;
}

-(void)loadGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleTapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.numberOfTapsRequired = 2;//点击的次数
    tapGesture.numberOfTouchesRequired = 1;//手指的个数
    [self.headImgScrollView addGestureRecognizer:tapGesture];
    [self.headImgScrollView.headImgView addGestureRecognizer:tapGesture];
}


#pragma mark -UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editType) {
        case userInfoEditTypeSignature:
            return 96;
            break;
        case userInfoEditTypeHeadImg:
            return 600;
        default:
            return 40;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (editType) {
        case userInfoEditTypeHeadImg:
            return 0.0001f;
            break;
            
        default:
            return 15;
            break;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (editType) {
        case userInfoEditTypeHeadImg:
            return 0;
            break;
            
        default:
            return 10;
            break;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (editType) {
        case userInfoEditTypeName:
            break;
        case userInfoEditTypeSex:
        {
            WCProfileTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            switch (cell.accessoryType) {
                case UITableViewCellAccessoryCheckmark:
                    [self.navigationController popViewControllerAnimated:YES];//没有修改性别，直接返回
                    break;
                default:
                    self.editGenderIndexPath = indexPath;
                    [self saveEditGender];
                    [self.navigationController popViewControllerAnimated:YES];//修改性别，返回
                    break;
            }
        }
            break;
        default:
            NSLog(@"cell调用异常");
            break;
    }
    NSLog(@"点击cell");
}
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (editType) {
        case userInfoEditTypeAddress:
            return 1;//************我的地址,默认为1，待修改，根据用户设定的地址数量调整
            break;
        case userInfoEditTypeLocal:
            return 2;//*************定位 默认为2，第一区为定位，第二区为手动选择地点 待调整
            break;
        case userInfoEditTypeHeadImg:
            return 1;
            break;
        default:
            return 1;
            break;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (editType) {
        case userInfoEditTypeSex:
            return 2;
            break;
        case userInfoEditTypeLocal:
            if (section==0) {
                return 1;
            }else return 30;
            break;
        case userInfoEditTypeHeadImg:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editType) {
        case userInfoEditTypeName:
            //UITextField in VC
        {
            WCProfileTableViewCell *editNameCell = [tableView dequeueReusableCellWithIdentifier:eidtUserInfoTableVCCellIdentifier];
            if (editNameCell==nil) {
                editNameCell = [[WCProfileTableViewCell alloc]initEditUserInfoTypeNameFieldWithStyle:UITableViewCellStyleDefault reuseIdentifier:eidtUserInfoTableVCCellIdentifier];
            }
            editNameCell.cellTextField.delegate = self;
            editNameCell.cellTextField.text = [self.userInfo valueForKey:@"wiiName"];
            if ([editNameCell.cellTextField canBecomeFirstResponder]) {
                [editNameCell.cellTextField becomeFirstResponder];
            }
            self.editNameTextField = editNameCell.cellTextField;
            return editNameCell;
            
        }
            break;
        case userInfoEditTypeSex:
        {
            WCProfileTableViewCell *editGenderCell = [tableView dequeueReusableCellWithIdentifier:eidtUserInfoTableVCCellIdentifier];
            if (editGenderCell==nil) {
                editGenderCell = [[WCProfileTableViewCell alloc]initEditUserInfoTypeGenderWithStyle:UITableViewCellStyleDefault reuseIdentifier:eidtUserInfoTableVCCellIdentifier];
            }
            switch (indexPath.row) {
                case 0:
                    editGenderCell.cellNameLabel.text = @"男";
                    break;
                    
                default:
                    editGenderCell.cellNameLabel.text = @"女";
                    break;
            }
            if ([[self.userInfo valueForKey:@"wiiSex"] isEqualToString:@"男"]) {
                if (indexPath.row==0) {
                    editGenderCell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }else if ([[self.userInfo valueForKey:@"wiiSex"] isEqualToString:@"女"]){
                if (indexPath.row==1) {
                    editGenderCell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            return editGenderCell;
        }
            break;
        case userInfoEditTypeSignature:
        {
            WCProfileTableViewCell *editSignatureCell = [tableView dequeueReusableCellWithIdentifier:eidtUserInfoTableVCCellIdentifier];
            if (editSignatureCell==nil) {
                editSignatureCell = [[WCProfileTableViewCell alloc]initEditUserInfoTypeSignatureWithStyle:UITableViewCellStyleDefault reuseIdentifier:eidtUserInfoTableVCCellIdentifier];
            }
            editSignatureCell.cellTextView.text = [self.userInfo valueForKey:@"wiiSignature"];
            editSignatureCell.cellTextView.delegate = self;
            self.editSignatureTextView = editSignatureCell.cellTextView;
            if ([editSignatureCell.cellTextView canBecomeFirstResponder]) {
                [editSignatureCell.cellTextView becomeFirstResponder];
            }
            editSignatureCell.cellDetailLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.countStringHelper restCountLength:[self.userInfo valueForKey:@"wiiSignature"]]];//剩余可输入字符长度
            self.editSignatureCountLabel = editSignatureCell.cellDetailLabel;
            return editSignatureCell;
        }
            break;
        case userInfoEditTypeHeadImg:
        {
            self.view.backgroundColor = [UIColor blackColor];
            WCProfileTableViewCell *editHeadImgCell = [tableView dequeueReusableCellWithIdentifier:eidtUserInfoTableVCCellIdentifier];
            if (editHeadImgCell==nil) {
                editHeadImgCell = [[WCProfileTableViewCell alloc]initEditUserInfoTypeHeadImgWithStyle:UITableViewCellStyleDefault reuserIdentifier:eidtUserInfoTableVCCellIdentifier];
            }
            [editHeadImgCell.backgroundView addSubview:self.headImgScrollView];
            return editHeadImgCell;
        }
        default:{
            WCProfileTableViewCell *headTableViewCell = [[WCProfileTableViewCell alloc]initUserInfoHeadCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:eidtUserInfoTableVCCellIdentifier];// coredata
            if ([self.userInfo valueForKey:@"wiiHeadImg"]!=nil) {
                headTableViewCell.cellImgView.image = [UIImage imageWithData:[self.userInfo valueForKey:@"wiiHeadImg"]];
            }else{
                headTableViewCell.cellImgView.image = [UIImage imageNamed:@"DefaultHeadImg"];
            }
            headTableViewCell.cellNameLabel.text = @"头像";
            headTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return headTableViewCell;
        }
            break;
    }
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.editNameTextField resignFirstResponder];
    
    return YES;
}
#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    self.headImgScrollView.headImgView.image = resultImage;//****保存选择的相片至数据库中
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        [photoVC setSizeClip:CGSizeMake(self.headImgScrollView.headImgView.width, self.headImgScrollView.headImgView.height)];
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UIScrollView Delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.headImgScrollView.headImgView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if (scrollView.pinchGestureRecognizer.numberOfTouches==2) {
        CGPoint p1 = [scrollView.pinchGestureRecognizer locationOfTouch:0 inView:self.headImgScrollView.headImgView];
        CGPoint p2 = [scrollView.pinchGestureRecognizer locationOfTouch:1 inView:self.headImgScrollView.headImgView];
        CGPoint pointCenter = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        NSLog(@"pointCenter:%@",NSStringFromCGPoint(pointCenter));
    }
    [scrollView setZoomScale:scale animated:YES];
}


#pragma mark - UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.editSignatureTextView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"testDelete");
    NSInteger existedLength = [self.countStringHelper existedStringLength1:self.editSignatureTextView.text]/2;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength >MAX_STARWORDS_LENGTH) {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textviewchanged");
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange&&position) {
        NSInteger existedLength = [self.countStringHelper existedStringLength:textView.text]/2;
        NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
        if (restCount<=0) {
            restCount=0;
        }
        self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
        return;
    }else if (selectedRange==nil&&position==nil){
        if ([self.countStringHelper judgementString:textView.text]==-1) {
            NSInteger existedLength = [self.countStringHelper existedStringLength:textView.text]/2;
            NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
            if (restCount<=0) {
                restCount=0;
            }
            self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
            return;
        }
        [textView setText:[textView.text substringToIndex:[self.countStringHelper judgementString:textView.text]]];
        NSInteger existedLength = [self.countStringHelper existedStringLength:self.editSignatureTextView.text]/2;
        NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
        if (restCount<=0) {
            restCount=0;
        }
        self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
    }
}

#pragma mark - helper method

//字符统计
-(void)textViewEditChanged:(NSNotification*)obj{
    NSLog(@"testDelete1");
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *data = [toBeString dataUsingEncoding:enc];
        NSInteger dataLength = [data length];
        if(dataLength>MAX_STARWORDS_LENGTH){
            int textLength = (int)[toBeString length];
            for (int i=0; i<textLength; i++) {
                NSString *fromString = [toBeString substringToIndex:i];
                NSStringEncoding enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSData *data2 = [fromString dataUsingEncoding:enc2];
                NSInteger fromDataLength2 = [data2 length];
                if (fromDataLength2==12) {
                    textView.text = fromString;
                }
            }
        }
    }else{
        textView.text = toBeString;
    }
    
}
-(void)textViewEditChanged1:(NSNotification*)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    //NSInteger changeLength = 0;
    NSLog(@"testDelete1");
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制 优化第三方输入法
        if (!position)
        {
            
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textView.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textView.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    
}
//***缩放方法1：修改scrollView的bounds值改变图像位置后缩放。 缺点：先改变位置后缩放动画不连续！
//-(void)scaleTapGesture:(UIGestureRecognizer*)tapGesture{
//    CGPoint p1 = [tapGesture locationOfTouch:0 inView:self.view];
//    CGFloat tempX = p1.x - self.view.center.x;
//    CGFloat tempY = p1.y - self.view.center.y;
//    NSLog(@"tapGesture location:%@",NSStringFromCGPoint(p1));
//    NSLog(@"双击缩放图片");
//    if (self.scrollView.zoomScale>1.0) {
//        [self.scrollView setZoomScale:1.0 animated:YES];
//        //self.editHeadImgView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.scrollView.bounds.size.height-400);
//        [self.scrollView setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 810)];
//        _scrollView.scrollEnabled = NO;
//    }else{
//        NSLog(@"original bounds :%@",NSStringFromCGRect(self.scrollView.bounds));
//        self.scrollView.contentOffset = CGPointMake(100, 100);
//        if (p1.x>=self.view.center.x&&p1.y>=self.view.center.y) {
//            [self.scrollView setBounds:CGRectMake(tempX, tempY, self.view.bounds.size.width, 810)];
//            NSLog(@"四象限");
//        }else if (p1.x<self.view.center.x&&p1.y>=self.view.center.y){
//            [self.scrollView setBounds:CGRectMake(tempX, tempY, self.view.bounds.size.width, 810)];
//            NSLog(@"三象限");
//        }else if (p1.x>=self.view.center.x&&p1.y<self.view.center.y){
//            [self.scrollView setBounds:CGRectMake(tempX, tempY, self.view.bounds.size.width, 810)];
//            NSLog(@"一象限");
//        }else{
//            [self.scrollView setBounds:CGRectMake(tempX, tempY, self.view.bounds.size.width, 810)];
//            NSLog(@"二象限");
//        }
//
//        NSLog(@"new bounds :%@",NSStringFromCGRect(self.scrollView.bounds));
//        [self.scrollView setZoomScale:2.0 animated:YES];
//        _scrollView.scrollEnabled = YES;
//    }
//}

//****缩放方法2 根据点击的center调整zoomRect
-(void)scaleTapGesture:(UIGestureRecognizer*)tapGesture{
    CGPoint p1 = [tapGesture locationOfTouch:0 inView:self.view];
        _headImgScrollView.scrollEnabled = YES;
        float newScale;
        if (!tapClicks) {
            newScale = self.headImgScrollView.zoomScale *2.0;
            _headImgScrollView.scrollEnabled = YES;
        }
        else{
            newScale = self.headImgScrollView.zoomScale *0.0;
            _headImgScrollView.scrollEnabled = NO;
        }
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:p1];
        [self.headImgScrollView zoomToRect:zoomRect animated:YES];
        tapClicks = !tapClicks;
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.headImgScrollView.frame.size.height / scale;
    zoomRect.size.width  =self.headImgScrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
// pop VC
-(void)popEditUserVC{
    //[self.view endEditing:YES];
    //    if (![self.editNameTextView isFirstResponder]&&![self.editNameTextField isFirstResponder]) {
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
    //NSLog(@"%@",self.editNameTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
    //    if ([self.editNameTextField isFirstResponder]) {
    //        [self.editNameTextField resignFirstResponder];
    //    }
    // [self.editNameTextField removeFromSuperview];
}
-(void)saveEditName{
    if ([[self.userInfo valueForKey:@"wiiName"]isEqualToString:self.editNameTextField.text]) {//未修改则直接返回
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];//保存修改的name信息
        [dic setValue:self.editNameTextField.text forKey:@"wiiName"];
        NSString *saveResult = [[EditUserInfoHelper sharedEditUserInfoHelper] saveChangesWithUserInfo:dic editChangetype:editType];
        if (![saveResult isEqualToString:@"修改用户信息成功"]) {
            [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
            [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@",saveResult]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        }else{
            NSLog(@"修改Name成功,newName = %@",self.editNameTextField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)saveEditGender{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString *saveResult;
    switch (self.editGenderIndexPath.row) {
        case 0:
            [dic setValue:@"男" forKey:@"wiiSex"];
            saveResult = [[EditUserInfoHelper sharedEditUserInfoHelper] saveChangesWithUserInfo:dic editChangetype:editType];
            if (![saveResult isEqualToString:@"修改用户信息成功"]) {
                [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
                [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
                [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@",saveResult]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    sleep(1);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        
                    });
                });
            }else{
                NSLog(@"修改Gender成功,newGender = 男");
            }
            break;
        default:
            [dic setValue:@"女" forKey:@"wiiSex"];
            saveResult = [[EditUserInfoHelper sharedEditUserInfoHelper] saveChangesWithUserInfo:dic editChangetype:editType];
            if (![saveResult isEqualToString:@"修改用户信息成功"]) {
                [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
                [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
                [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@",saveResult]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    sleep(1);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        
                    });
                });
            }else{
                NSLog(@"修改Gender成功,newGender = 女");
            }
            break;
    }
}
-(void)saveEditSignature{
    if ([self.editSignatureTextView.text isEqualToString:[self.userInfo  valueForKey:@"wiiSignature"]]||[self.editSignatureTextView.text isEqual:@""]) {
        [self.navigationController popViewControllerAnimated:YES];  //未修改或为空 直接返回
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
        NSString *saveResult;
        [dic setValue:self.editSignatureTextView.text forKey:@"wiiSignature"];
        saveResult = [[EditUserInfoHelper sharedEditUserInfoHelper]saveChangesWithUserInfo:dic editChangetype:userInfoEditTypeSignature];
        if (![saveResult isEqualToString:@"修改用户信息成功"]) {
            [SVProgressHUD setFont:[UIFont fontWithName:@"Arial" size:13.0f]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//背景风格
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//动画类型
            [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -30.0f)];
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@",saveResult]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        }else{
            NSLog(@"修改Signature成功,newSignature = %@",self.editSignatureTextView.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)choseHeadImg{
    NSLog(@"选择照片");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }
    }]];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
\
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
