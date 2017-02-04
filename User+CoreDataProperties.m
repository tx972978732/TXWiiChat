//
//  User+CoreDataProperties.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic wiiEmail;
@dynamic wiiError;
@dynamic wiiHeadImg;
@dynamic wiiID;
@dynamic wiiLogin;
@dynamic wiiName;
@dynamic wiiPassword;
@dynamic wiiPhoto;
@dynamic wiiSex;
@dynamic wiiSignature;
@dynamic wiiAddress;
@dynamic contact;

@end
