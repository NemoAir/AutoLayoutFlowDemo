//
//  AutoResizeCell.m
//  AutolayoutFlowDemo
//
//  Created by Nemo on 15/3/12.
//  Copyright (c) 2015年 Nemo. All rights reserved.
//

#import "AutoResizeCell.h"

@implementation AutoResizeCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor blackColor];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateConstraints {
    
    [self.contentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  
    [super updateConstraints];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
    
}
@end
