//
//  WCBaseSearchBar.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCBaseSearchBar.h"

@implementation WCBaseSearchBar

- (void)layoutSubviews{
    self.autoresizesSubviews = YES;
    UITextField *searchField = [self eaTextField];
    [searchField setFrame:CGRectMake(10, 4.5, self.frame.size.width-75, 22)];
    searchField.leftView = nil;
    searchField.textAlignment = NSTextAlignmentLeft;
    
}

- (UITextField *)eaTextField{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIView *candidateView, NSDictionary *bindings) {
        return [candidateView isMemberOfClass:NSClassFromString(@"UISearchBarTextField")];
    }];
    return [self.subviews.firstObject.subviews filteredArrayUsingPredicate:predicate].lastObject;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
