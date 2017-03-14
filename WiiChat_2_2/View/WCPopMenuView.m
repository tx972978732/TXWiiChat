//
//  WCPopMenuView.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCPopMenuView.h"
#import <Masonry/Masonry.h>
#import "WCPopMenuTableViewCell.h"
@interface WCPopMenuView ()
@property(nonatomic,strong)NSArray *menus;
@property(nonatomic,strong)UITableView *menuTableView;
@property(nonatomic,strong)UIImageView *menuContainerView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)UIView *currentSuperView;
@property(nonatomic,assign)CGPoint targetPoint;

@end

@implementation WCPopMenuView
- (instancetype)initWithMenus:(NSArray*)menus{
    self = [super init];
    if (self) {
        self.menus = menus;
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.frame = [[UIScreen mainScreen]bounds];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.menuContainerView];
}

- (void)setUpConstraints{
    [_menuContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.bounds.size.width-WCMenuTableViewWidth-6);
        if ([self.currentSuperView.superview isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")]) {
            make.top.equalTo(self.currentSuperView.superview).with.offset(65);
        }
        make.width.equalTo(@WCMenuTableViewWidth);
        make.height.equalTo(@(self.menus.count*(WCMenuItemViewHeight+WCSeparatorLineImageViewHeight)+WCMenuTableViewSpacing));
    }];
    [_menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuContainerView);
        make.top.equalTo(self.menuContainerView).offset(WCMenuTableViewSpacing);
        make.width.equalTo(self.menuContainerView);
        make.height.equalTo(self.menuContainerView);
    }];

}

- (UIImageView*)menuContainerView{
    if (_menuContainerView) {
        return _menuContainerView;
    }
    _menuContainerView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"MoreFunctionFrame"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 50) resizingMode:UIImageResizingModeTile]];//平铺
    _menuContainerView.userInteractionEnabled = YES;
    [_menuContainerView addSubview:self.menuTableView];
    return _menuContainerView;
}

- (UITableView*)menuTableView{
    if (_menuTableView) {
        return _menuTableView;
    }
    _menuTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.separatorColor = [UIColor clearColor];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.rowHeight = WCMenuItemViewHeight;
    _menuTableView.scrollEnabled = NO;

    return _menuTableView;
}

-(void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point{
    self.currentSuperView = view;
    self.targetPoint = point;
    [self showMenu];
}
-(void)showMenuAtPoint:(CGPoint)point{
    [self showMenuOnView:[[UIApplication sharedApplication] keyWindow] atPoint:point];
}

-(void)showMenu{
    if (![self.currentSuperView.subviews containsObject:self]) {
        self.alpha = 0.0;
        [self.currentSuperView addSubview:self];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        [self setUpConstraints];
    }else{
        [self dismissPopMenuAnimatedOnMenuSelected:NO];
    }
}


//手势响应
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    [self dismissPopMenuAnimatedOnMenuSelected:NO];

//    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
//        [self hitTest:localPoint withEvent:event];
//        NSLog(@"hit location:%@",NSStringFromCGPoint(localPoint));
//        NSLog(@"tableviewframe:%@",NSStringFromCGRect(self.menuTableView.frame));
//    }else{
//        [self dismissPopMenuAnimatedOnMenuSelected:NO];
//    }
}
-(void)dismissPopMenuAnimatedOnMenuSelected:(BOOL)selected{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (selected) {
            if(self.popMentDismissedBlock){
                self.popMentDismissedBlock(self.indexPath.row,self.menus[self.indexPath.row]);
            }
        }
        [super removeFromSuperview];
    }];
}

#pragma DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menus.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer= @"cellidentifer";
    WCPopMenuTableViewCell *popMenuItemView = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!popMenuItemView) {
        popMenuItemView = [[WCPopMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.row<self.menus.count) {
        [popMenuItemView setUpPopMenuItem:self.menus[indexPath.row] atIndexPath:indexPath isBottom:(indexPath.row == self.menus.count-1)];
    }
    return popMenuItemView;
}

#pragma Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    [self dismissPopMenuAnimatedOnMenuSelected:YES];
    if (self.popMenuDidSelectBlock) {
        NSString *logRe = [[NSString alloc]init];
        logRe =  self.popMenuDidSelectBlock(self.indexPath.row,self.menus[indexPath.row]);
        NSLog(@"%@",logRe);//闭包作为回调的测试  从vc中回传了一个logRe
    }
    NSLog(@"按下了按钮");
}



@end
