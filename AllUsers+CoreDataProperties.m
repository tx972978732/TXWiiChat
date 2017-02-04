//
//  AllUsers+CoreDataProperties.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/30.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "AllUsers+CoreDataProperties.h"

@implementation AllUsers (CoreDataProperties)

+ (NSFetchRequest<AllUsers *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AllUsers"];
}

@dynamic wiiAddress;
@dynamic wiiContact;
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

@end
