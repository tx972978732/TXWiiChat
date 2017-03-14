//
//  WCPopMenuItem.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WCMenuTableViewWidth 122
#define WCMenuTableViewSpacing 7
#define WCMenuItemViewHeight 36
#define WCMuneItemImageSpacing 15
#define WCSeparatorLineImageViewHeight 1

@interface WCPopMenuItem : NSObject
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *title;

-(instancetype)initPopMenuItemWithImage:(UIImage*)image title:(NSString*)title;
@end
