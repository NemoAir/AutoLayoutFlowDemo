//
//  BridgeView.m
//  AutoLayout
//
//  Created by Nemo on 15/3/4.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import "BridgeView.h"

@implementation BridgeView
+ (BOOL)xx_shouldApplyNibBridging{
    return YES;
    //需要这个view使用动态桥接功能，只要将这个方法返回YES即可。
}
-(void)updateConstraints{
    [super updateConstraints];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

@end
