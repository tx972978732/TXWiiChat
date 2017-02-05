//
//  Contact+CoreDataClass.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/12/1.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "Contact.h"
#import "User.h"
#import "WiiChatCoreDataStackManager.h"
#import "ChineseString.h"
@implementation Contact
+ (NSFetchedResultsController*)contactFetchedResultsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    NSSortDescriptor *sectionSort = [NSSortDescriptor sortDescriptorWithKey:@"sectionName" ascending:YES];
    NSSortDescriptor *rowSort = [NSSortDescriptor sortDescriptorWithKey:@"rowName" ascending:YES];
    request.sortDescriptors = @[sectionSort,rowSort];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[Contact getLocalMOC] sectionNameKeyPath:@"sectionName" cacheName:nil];
    return fetchedResultsController;
}

+ (NSString*)convertRowNameFromWiiName:(NSString*)wiiName{
    //*****英文字符和标点字符筛选
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)wiiName);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    return (__bridge NSString * _Nonnull)(string);
}
+ (NSManagedObjectContext*)getLocalMOC{
    return [[WiiChatCoreDataStackManager sharedManager]managedObjectContext];
}
+ (NSString*)convertSectionNameFromWiiName:(NSString*)wiiName{
    NSArray *tempArray = @[wiiName];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    resultArray = [ChineseString IndexArray:tempArray];
    NSString *convertResult = [resultArray firstObject];
    return convertResult;
}
@end
