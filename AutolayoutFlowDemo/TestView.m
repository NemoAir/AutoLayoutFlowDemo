//
//  TestView.m
//  AutoLayout
//
//  Created by Nemo on 15/3/4.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import "TestView.h"

@implementation TestView

-(void)layoutSubviews{
    [super layoutSubviews];
    //这个方法会触发所有subviews 的约束更新方法
}
-(void)updateConstraints{
    [super updateConstraints];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setNeedsUpdateConstraints{
    [super setNeedsUpdateConstraints];
}
@end
