//
//  Contact+CoreDataProperties.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/12/1.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "Contact.h"


NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *sectionName;
@property (nullable, nonatomic, copy) NSString *wiiAddress;
@property (nullable, nonatomic, copy) NSString *wiiEmail;
@property (nullable, nonatomic, copy) NSString *wiiError;
@property (nullable, nonatomic, retain) NSData *wiiHeadImg;
@property (nullable, nonatomic, copy) NSString *wiiID;
@property (nullable, nonatomic, copy) NSString *wiiName;
@property (nullable, nonatomic, retain) NSData *wiiPhoto;
@property (nullable, nonatomic, copy) NSString *wiiSex;
@property (nullable, nonatomic, copy) NSString *wiiSignature;
@property (nullable, nonatomic, copy) NSString *rowName;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
