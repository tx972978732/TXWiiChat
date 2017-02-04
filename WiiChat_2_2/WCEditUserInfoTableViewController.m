//
//  WCEditUserInfoTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/10.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCEditUserInfoTableViewController.h"
#import "WCProfileTableViewCell.h"
#import "EditUserInfoHelper.h"
#import "SVProgressHUD.h"
#import "YQImageTool.h"



#define MAX_STARWORDS_LENGTH 30
@interface WCEditUserInfoTableViewController ()
@property(nonatomic,strong)UITextField *editNameTextField;
@property(nonatomic,strong)UITextView *editNameTextView;
@property(nonatomic,strong)NSMutableDictionary *userInfo;
@property(nonatomic,strong)NSIndexPath *editGenderIndexPath;
@property(nonatomic,strong)UITextView *editSignatureTextView;
@property(nonatomic,strong)UILabel *editSignatureCountLabel;
@property(nonatomic,strong)UIImageView *editHeadImgView;
@end

NSString *const eidtUserInfoTableVCCellIdentifier = @"eidtUserInfoTableVCCellIdentifier";

@implementation WCEditUserInfoTableViewController
static userInfoEditType editType;
static NSInteger characterLength;

#pragma mark - life cycle
-(instancetype)initWithUserInfoEditType:(userInfoEditType)type userInfo:(NSMutableDictionary *)userInfo{
    self = [super init];
    if (self) {
        self.userInfo = userInfo;
        editType = type;
        if (editType==userInfoEditTypeHeadImg) {
            self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;

        }else{
            self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;

        }
            NSLog(@"editType1:%ld",(long)editType);
            //[self.view addSubview:self.tableView];
        
    }
    return self;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    if (editType==userInfoEditTypeHeadImg) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableViewCell.backgroundColor = [UIColor clearColor];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 810)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 2;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        //[self.view addSubview:self.scrollView];
        self.editHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height-400)];
        //self.editHeadImgView.image = [UIImage imageWithData:[self.userInfo valueForKey:@"wiiHeadImg"]];
        self.editHeadImgView.image = [UIImage imageNamed:@"TestHeadImg.jpg"];
        //self.editHeadImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollView.contentSize = self.editHeadImgView.frame.size;
        [self.scrollView addSubview:self.editHeadImgView];
        [self loadGesture];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//        self.userInfo = nil;
//        self.editNameTextField.delegate = nil;
//        self.editNameTextField = nil;
//        self.tableView.delegate = nil;
//        self.tableView.dataSource = nil;
//    self.tableView = nil;
    NSLog(@"WCEditUserTableViewController dealloc");
}
-(void)loadGesture{
    self.editHeadImgView.userInteractionEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleTapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.numberOfTapsRequired = 2;//点击的次数
    tapGesture.numberOfTouchesRequired = 1;//手指的个数
    [self.scrollView addGestureRecognizer:tapGesture];
    [self.editHeadImgView addGestureRecognizer:tapGesture];
}

-(void)loadEditSignatureTextView{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.editSignatureTextView];//限制字符串长度
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
            
            if ([[self.userInfo valueForKey:@"wiiSex"] isEqualToString:@"男"]) {
                switch (indexPath.row) {
                    case 0:
                        editGenderCell.cellNameLabel.text = @"男";
                        editGenderCell.accessoryType = UITableViewCellAccessoryCheckmark;
                        break;
                        
                    default:
                        editGenderCell.cellNameLabel.text = @"女";
                        editGenderCell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                }
            }else if ([[self.userInfo valueForKey:@"wiiSex"] isEqualToString:@"女"]){
                switch (indexPath.row) {
                    case 0:
                        editGenderCell.cellNameLabel.text = @"男";
                        editGenderCell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                        
                    default:
                        editGenderCell.cellNameLabel.text = @"女";
                        editGenderCell.accessoryType = UITableViewCellAccessoryCheckmark;
                        break;
                }
            }else{
                switch (indexPath.row) {
                    case 0:
                        editGenderCell.cellNameLabel.text = @"男";
                        editGenderCell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                        
                    default:
                        editGenderCell.cellNameLabel.text = @"女";
                        editGenderCell.accessoryType = UITableViewCellAccessoryNone;
                        break;
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
           // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:editSignatureCell.cellTextView];//限制字符串长度
            self.editSignatureTextView = editSignatureCell.cellTextView;
            if ([editSignatureCell.cellTextView canBecomeFirstResponder]) {
                [editSignatureCell.cellTextView becomeFirstResponder];
            }
            NSInteger userInfoSignatureCount = [self existedStringLength:[self.userInfo valueForKey:@"wiiSignature"]]/2;
            NSInteger restCount = MAX_STARWORDS_LENGTH - userInfoSignatureCount;
            if (restCount<=0) {
                restCount=0;
            }
            editSignatureCell.cellDetailLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
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
            [editHeadImgCell.backgroundView addSubview:self.scrollView];
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
    self.editHeadImgView.image = resultImage;
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        [photoVC setSizeClip:CGSizeMake(self.editHeadImgView.width, self.editHeadImgView.height)];
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UIScrollView Delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.editHeadImgView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale animated:YES];
}


#pragma mark - UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    //[self.view endEditing:YES];
    [self.editSignatureTextView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length==0) {
//        return YES;
//    }
    NSLog(@"testDelete");
    NSInteger existedLength = [self existedStringLength1:self.editSignatureTextView.text]/2;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
//    NSInteger restLength = MAX_STARWORDS_LENGTH - existedLength - replaceLength;
//    if (restLength>=0) {
//        self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restLength];
//    }else{
//        self.editSignatureCountLabel.text = @"0";
//    }
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
        NSInteger existedLength = [self existedStringLength:textView.text]/2;
        NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
        if (restCount<=0) {
            restCount=0;
        }
        self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
        return;
    }else if (selectedRange==nil&&position==nil){
        if ([self judgementString:textView.text]==-1) {
            NSInteger existedLength = [self existedStringLength:textView.text]/2;
            NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
            if (restCount<=0) {
                restCount=0;
            }
            self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
            return;
        }
        [textView setText:[textView.text substringToIndex:[self judgementString:textView.text]]];
        NSInteger existedLength = [self existedStringLength:self.editSignatureTextView.text]/2;
        NSInteger restCount = MAX_STARWORDS_LENGTH - existedLength;
        if (restCount<=0) {
            restCount=0;
        }
        self.editSignatureCountLabel.text = [NSString stringWithFormat:@"%ld",(long)restCount];
    }
}

#pragma mark - helper method
-(NSInteger)existedStringLength:(NSString*)string{
     characterLength = 0;
    for(int i=0; i< [string length];++i){
        int a = [string characterAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%c",a];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            if ([self stringContainsEmoji:subString]!=0){
                NSLog(@"str:%@",str);
                NSInteger emojiCount = [self stringContainsEmoji:subString];
                NSLog(@"emojiCount:%ld",(long)emojiCount);
                characterLength +=(4*emojiCount);//表情的字符长度判断
            }
            i+=1;
        }else{
            if((a >= 0x4e00 && a <= 0x9fa5)||(strlen(cString)==3)){ //判断是否为中文
                characterLength +=2;
            }else{
                characterLength +=1;
            }
        }
    }
    NSLog(@"当前字符串长度%ld",(long)characterLength/2);
    if ((characterLength%2)==0) {//输入1个英文、数字字符时立即显示占用1位（即显示剩余字数时，不足1时取整显示）
        return characterLength;
    }else{
        return characterLength+1;
    }
    //return characterLength;
}
-(NSInteger)existedStringLength1:(NSString*)string{//计算已存在的字符长度时，按实际占用长度计算
    characterLength = 0;
    for(int i=0; i< [string length];++i){
        int a = [string characterAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%c",a];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            if ([self stringContainsEmoji:subString]!=0){
                NSLog(@"str:%@",str);
                NSInteger emojiCount = [self stringContainsEmoji:subString];
                NSLog(@"emojiCount:%ld",(long)emojiCount);
                characterLength +=(4*emojiCount);//表情的字符长度判断
            }
            i+=1;
        }else{
            if((a >= 0x4e00 && a <= 0x9fa5)||(strlen(cString)==3)){ //判断是否为中文
                characterLength +=2;
            }else{
                characterLength +=1;
            }
        }
    }
    NSLog(@"当前字符串长度%ld",(long)characterLength/2);
    return characterLength;
}
-(NSInteger)judgementString:(NSString*)string{
    NSInteger count = 0;
    for (int i=0; i<string.length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString==NULL) {
            range = NSMakeRange(i, 2);
            subString = [string substringWithRange:range];
            NSLog(@"subStrlength:%ld , subString:%@",(long)subString.length,subString);
            NSLog(@"strlength:%ld",(long)string.length);
            if ([self stringContainsEmoji:subString]!=0) {
                NSLog(@"judgement emoji");
                NSData *data = [subString dataUsingEncoding:NSNonLossyASCIIStringEncoding];
                NSString *goodValue = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if (goodValue.length == 6) {
                    if ((count+2)>MAX_STARWORDS_LENGTH*2) {
                        return i;
                    }else
                        count+=2;
                }else{
                    if ((count+2)>MAX_STARWORDS_LENGTH*2) {
                        return i;
                    }else
                        count+=2;
                }
                i+=1;
            }
        }else if (strlen(cString)==3){
            if ((count+2)>MAX_STARWORDS_LENGTH*2) {
                return i;
            }else
                count+=2;
        }else{
            if ((count+1)>MAX_STARWORDS_LENGTH*2) {
                return i;
            }else
                count+=1;
        }
    }
    return -1;
}
- (NSInteger)stringContainsEmoji:(NSString *)string{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block NSInteger returnValue = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue +=1;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue +=1;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue +=1;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue +=1;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue +=1;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue +=1;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue +=1;
            }
        }
    }];
    NSInteger result = returnValue;
    return result;
}

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

-(void)scaleTapGesture:(UIGestureRecognizer*)tapGesture{
    NSLog(@"双击缩放图片");
    //self.editHeadImgView.image = [YQImageTool getThumbImageWithImage:[UIImage imageNamed:@"TestHeadImg"] andSize:CGSizeMake(50, 50) Scale:NO];
//    self.editHeadImgView.frame = CGRectMake(0, 180, 100, 100);
//    self.editHeadImgView.image = [YQImageTool getCornerImageFillSize:CGSizeMake(50, 50) WithImage:[UIImage imageNamed:@"TestHeadImg"] andCornerWith:5.0f andBackGroundColor:[UIColor clearColor]];
    
//    float newScale = self.scrollView.zoomScale * 0.5;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGesture locationInView:tapGesture.view]];
//    [self.scrollView zoomToRect:zoomRect animated:YES];
    if (self.scrollView.zoomScale>1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else{
        [self.scrollView setZoomScale:2.0 animated:YES];
    }
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
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
