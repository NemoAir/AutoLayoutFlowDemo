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
    [super awakeFromNib];
    for(NSLayoutConstraint *cellConstraint in self.constraints){
        [self removeConstraint:cellConstraint];
        id firstItem = cellConstraint.firstItem == self ? self.contentView : cellConstraint.firstItem;
        id seccondItem = cellConstraint.secondItem == self ? self.contentView : cellConstraint.secondItem;
        NSLayoutConstraint* contentViewConstraint =
        [NSLayoutConstraint constraintWithItem:firstItem
                                     attribute:cellConstraint.firstAttribute
                                     relatedBy:cellConstraint.relation
                                        toItem:seccondItem
                                     attribute:cellConstraint.secondAttribute
                                    multiplier:cellConstraint.multiplier
                                      constant:cellConstraint.constant];
        [self.contentView addConstraint:contentViewConstraint];
    }
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
    
//    [self.contentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
//    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  
    [super updateConstraints];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
    
}
@end
