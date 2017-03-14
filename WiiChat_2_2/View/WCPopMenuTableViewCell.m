//
//  WCPopMenuTableViewCell.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/13.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCPopMenuTableViewCell.h"

@interface WCPopMenuTableViewCell ()
@property(nonatomic,strong)UIView *menuCellBackgroundView;
@property(nonatomic,strong)UIImageView *separatorLineImageView;
@end

@implementation WCPopMenuTableViewCell

#pragma LifeCycle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        
        self.selectedBackgroundView = self.menuCellBackgroundView;
        [self.contentView addSubview:self.separatorLineImageView];
    }
    return self;
}

//-(void)setFrame:(CGRect)frame{
//    frame.origin.y += 1;
//    frame.size.height -= 1;
//    [super setFrame:frame];
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame)+5;
    textLabelFrame.size.width += 15;
    self.textLabel.frame = textLabelFrame;
    
}


-(void)setUpPopMenuItem:(WCPopMenuItem*)popMenuItem atIndexPath:(NSIndexPath*)indexPath isBottom:(BOOL)isBottom{
    self.menuItem = popMenuItem;
    self.textLabel.text = popMenuItem.title;
    self.imageView.image = popMenuItem.image;
    self.separatorLineImageView.hidden = isBottom;

}

#pragma Property
-(UIView*)menuCellBackgroundView{
    if (!_menuCellBackgroundView) {
        _menuCellBackgroundView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        _menuCellBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuCellBackgroundView.backgroundColor = [UIColor colorWithRed:0.216 green:0.242 blue:0.263 alpha:0.9];
    }
    return _menuCellBackgroundView;
}
-(UIImageView*)separatorLineImageView{
    if (!_separatorLineImageView) {
        _separatorLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WCMuneItemImageSpacing, WCMenuItemViewHeight-WCSeparatorLineImageViewHeight, WCMenuTableViewWidth-WCMenuTableViewSpacing*4, WCSeparatorLineImageViewHeight)];
        _separatorLineImageView.backgroundColor  = [UIColor colorWithRed:0.468 green:0.519 blue:0.549 alpha:0.900];
    }
    return _separatorLineImageView;
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
