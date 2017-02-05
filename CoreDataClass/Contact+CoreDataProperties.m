//
//  Contact+CoreDataProperties.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/12/1.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "Contact+CoreDataProperties.h"

@implementation Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
}

@dynamic sectionName;
@dynamic wiiAddress;
@dynamic wiiEmail;
@dynamic wiiError;
@dynamic wiiHeadImg;
@dynamic wiiID;
@dynamic wiiName;
@dynamic wiiPhoto;
@dynamic wiiSex;
@dynamic wiiSignature;
@dynamic rowName;
@dynamic user;

@end
