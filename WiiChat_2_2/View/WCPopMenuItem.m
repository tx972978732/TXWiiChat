//
//  WCPopMenuItem.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCPopMenuItem.h"

@implementation WCPopMenuItem
-(instancetype)initPopMenuItemWithImage:(UIImage*)image title:(NSString*)title{
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
    }
    return self;
}
@end
