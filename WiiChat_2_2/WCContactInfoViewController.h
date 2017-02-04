//
//  WCContactInfoViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCBaseTableViewController.h"
#import "AllUsers.h"
#import "UserSource.h"
#import "Contact.h"
typedef NS_ENUM(NSInteger,contactRelationship){
    alreadyAddedIntoContact,
    neverAddedIntoContact,
    alreadyRequestedForAddIntoContact
};
@interface WCContactInfoViewController : WCBaseTableViewController
-(id)initWithUserInfo:(AllUsers*)info Relationship:(contactRelationship)relationship;
-(id)initWithContactInfo:(Contact*)info Relationship:(contactRelationship)relationship;
@end
