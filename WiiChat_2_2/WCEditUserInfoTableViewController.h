//
//  WCEditUserInfoTableViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/10.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseTableViewController.h"
#import "User.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"
typedef NS_ENUM(NSInteger,userInfoEditType) {
    userInfoEditTypeHeadImg,
    userInfoEditTypeName,
    userInfoEditTypeQRCode,
    userInfoEditTypeAddress,
    userInfoEditTypeSex,
    userInfoEditTypeLocal,
    userInfoEditTypeSignature
};
@interface WCEditUserInfoTableViewController : WCBaseTableViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,STPhotoKitDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

-(instancetype)initWithUserInfoEditType:(userInfoEditType)type userInfo:(NSMutableDictionary*)userInfo;
@end
