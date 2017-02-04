//
//  AllUsers+CoreDataProperties.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/30.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "AllUsers.h"


NS_ASSUME_NONNULL_BEGIN

@interface AllUsers (CoreDataProperties)

+ (NSFetchRequest<AllUsers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *wiiAddress;
@property (nullable, nonatomic, retain) NSMutableDictionary *wiiContact;
@property (nullable, nonatomic, copy) NSString *wiiEmail;
@property (nullable, nonatomic, copy) NSString *wiiError;
@property (nullable, nonatomic, retain) NSData *wiiHeadImg;
@property (nullable, nonatomic, copy) NSString *wiiID;
@property (nullable, nonatomic, copy) NSString *wiiLogin;
@property (nullable, nonatomic, copy) NSString *wiiName;
@property (nullable, nonatomic, copy) NSString *wiiPassword;
@property (nullable, nonatomic, retain) NSData *wiiPhoto;
@property (nullable, nonatomic, copy) NSString *wiiSex;
@property (nullable, nonatomic, copy) NSString *wiiSignature;

@end

NS_ASSUME_NONNULL_END
