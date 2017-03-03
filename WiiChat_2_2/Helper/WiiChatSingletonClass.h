//
//  WiiChatSingletonClass.h
//  WiiChat_2_2
//
//  Created by 童煊 on 16/9/20.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WiiSingletonClass_Header(ClassName)\
\
+(ClassName*)shared##ClassName;

#define WiiSingletonClass_Implementation(ClassName)\
\
static ClassName *shared##ClassName = nil;\
static dispatch_once_t pred;\
\
+(ClassName*)shared##ClassName{\
dispatch_once(&pred,^{\
shared##ClassName = [[self alloc] init];\
});\
return shared##ClassName;\
}

@interface WiiChatSingletonClass : NSObject

@end
