//
//  WCUIStoreManager.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/8.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCUIStoreManager.h"
#import "User.h"

@implementation WCUIStoreManager
WiiSingletonClass_Implementation(WCUIStoreManager)

-(NSMutableArray*)getProfileUIDataSource{
    NSMutableArray *UIDataSource = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *section_1_Dic_0 = @{@"title":@"相册",@"image":@"MyAlbum"};
    NSDictionary *section_1_Dic_1 = @{@"title":@"收藏",@"image":@"MyFavorites"};
    NSDictionary *section_1_Dic_2 = @{@"title":@"钱包",@"image":@"MyWallet"};
    NSDictionary *section_1_Dic_3 = @{@"title":@"卡包",@"image":@"MyCards"};
    NSMutableArray *section1 = [[NSMutableArray alloc]initWithCapacity:4];
    [section1 addObject:section_1_Dic_0];
    [section1 addObject:section_1_Dic_1];
    [section1 addObject:section_1_Dic_2];
    [section1 addObject:section_1_Dic_3];
    
    NSDictionary *section_2_Dic_0 = @{@"title":@"表情",@"image":@"MoreEmotions"};
    NSMutableArray *section2 = [NSMutableArray arrayWithObject:section_2_Dic_0];
    
    NSDictionary *section_3_Dic_0 = @{@"title":@"设置",@"image":@"MySetting"};
    NSMutableArray *section3 = [NSMutableArray arrayWithObject:section_3_Dic_0];
    
    [UIDataSource addObject:section1];
    [UIDataSource addObject:section2];
    [UIDataSource addObject:section3];
    
    return UIDataSource;
}

-(NSMutableArray*)getAddContactUIDataSource{
    NSMutableArray *UIDataSource = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *section_0_Dic_0 = @{@"title":@"搜索",@"image":@"searchIcon"};
    NSMutableArray *section0 = [NSMutableArray arrayWithCapacity:1];
    [section0 addObject:section_0_Dic_0];
    NSDictionary *section_1_Dic_0 = @{@"title":@"雷达加朋友",@"detail":@"添加身边的朋友",@"image":@"leida"};
    NSDictionary *section_1_Dic_1 = @{@"title":@"面对面建群",@"detail":@"与身边的朋友进入同一个群聊",@"image":@"mianduimian"};
    NSDictionary *section_1_Dic_2 = @{@"title":@"扫一扫",@"detail":@"扫描二维码名片",@"image":@"saoyisao"};
    NSDictionary *section_1_Dic_3 = @{@"title":@"手机联系人",@"detail":@"添加通讯录中的朋友",@"image":@"shouji"};
    NSDictionary *section_1_Dic_4 = @{@"title":@"公众号",@"detail":@"获取更多资讯和服务",@"image":@"gongzhonghao"};
    NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
    [section1 addObject:section_1_Dic_0];
    [section1 addObject:section_1_Dic_1];
    [section1 addObject:section_1_Dic_2];
    [section1 addObject:section_1_Dic_3];
    [section1 addObject:section_1_Dic_4];
    
    [UIDataSource addObject:section0];
    [UIDataSource addObject:section1];
    return UIDataSource;
}
-(NSMutableArray*)getContactInfoUIDataSource{
    NSMutableArray *UIDataSource = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *strangerContactInfo = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *friendContactInfo = [NSMutableArray arrayWithCapacity:1];
    //陌生人UI
    if (strangerContactInfo) {
        NSDictionary *section_1_Dic_0 = @{@"title":@"设置备注和标签"};
        NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
        [section1 addObject:section_1_Dic_0];
        NSDictionary *section_2_Dic_0 = @{@"title":@"地区"};
        NSDictionary *section_2_Dic_1 = @{@"title":@"个性签名"};
        NSDictionary *section_2_Dic_2 = @{@"title":@"社交资料"};
        NSDictionary *section_2_Dic_3 = @{@"title":@"来源"};
        NSMutableArray *section2 = [NSMutableArray arrayWithCapacity:1];
        [section2 addObject:section_2_Dic_0];
        [section2 addObject:section_2_Dic_1];
        [section2 addObject:section_2_Dic_2];
        [section2 addObject:section_2_Dic_3];
        [strangerContactInfo addObject:section1];
        [strangerContactInfo addObject:section2];
    }
    //好友UI
    if (friendContactInfo) {
        NSDictionary *section_1_Dic_0 = @{@"title":@"设置备注和标签"};
        NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
        [section1 addObject:section_1_Dic_0];
        NSDictionary *section_2_Dic_0 = @{@"title":@"地区"};
        NSDictionary *section_2_Dic_1 = @{@"title":@"个人相册"};
        NSDictionary *section_2_Dic_2 = @{@"title":@"更多"};
        NSMutableArray *section2 = [NSMutableArray arrayWithCapacity:1];
        [section2 addObject:section_2_Dic_0];
        [section2 addObject:section_2_Dic_1];
        [section2 addObject:section_2_Dic_2];
        [friendContactInfo addObject:section1];
        [friendContactInfo addObject:section2];
    }
    [UIDataSource addObject:strangerContactInfo];
    [UIDataSource addObject:friendContactInfo];

    return UIDataSource;
}

-(NSMutableArray*)getRootContactUIDataSource{
    NSMutableArray *UIDataSource = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *section_0_Dic_0 = @{@"title":@"新的朋友",@"image":@"NewFriend"};
    NSDictionary *section_0_Dic_1 = @{@"title":@"群聊",@"image":@"GroupChat"};
    NSDictionary *section_0_Dic_2 = @{@"title":@"标签",@"image":@"Stamp"};
    NSDictionary *section_0_Dic_3 = @{@"title":@"公众号",@"image":@"PublicAccount"};
    [UIDataSource addObject:section_0_Dic_0];
    [UIDataSource addObject:section_0_Dic_1];
    [UIDataSource addObject:section_0_Dic_2];
    [UIDataSource addObject:section_0_Dic_3];
    return UIDataSource;
}
@end
