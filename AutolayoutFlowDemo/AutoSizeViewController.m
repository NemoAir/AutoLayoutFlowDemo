//
//  AutoSizeViewController.m
//  AutoLayout
//
//  Created by Nemo on 15/2/27.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import "AutoSizeViewController.h"

@interface AutoSizeViewController ()
@property (strong, nonatomic) IBOutlet UIView *layoutView;

@end

@implementation AutoSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.firstLabel.text = @"   YES,calulate the size use these text.";
    self.firstLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) -100;
    self.secondLabel.preferredMaxLayoutWidth = self.firstLabel.preferredMaxLayoutWidth;//label的这个属性可以告诉约束系统计算label的size时使用的最大宽度。IB里面也可以设置
    self.inputTextView.returnKeyType  = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size = [self.layoutView intrinsicContentSize];
    CGSize autoSize = [self.layoutView  systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];//这个方法是用约束系统来计算view现在的size
    self.secondLabel.text = [NSString stringWithFormat:@"intrinsicSize = %@,LayoutSize = %@",NSStringFromCGSize(size),NSStringFromCGSize(autoSize)];
    [self.view invalidateIntrinsicContentSize];//这个方法会调用 view及其subviews的intrinsicContentSize来计算现在正确的size 来设置view的frame
    
    //所以改变view的size有两个方法，一个是重载view的 - intrinsicContentSize方法，并通过调用-invalidateIntrinsicContentSize 方法来改变view的size。另一个是通过自动布局系统调用-systemLayoutSizeFittingSize 来重新布局

}


- (IBAction)animationViewSize:(id)sender {
    
    [self.inputTextView resignFirstResponder];
    self.firstLabel.text = self.inputTextView.text;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
   
    
}
@end
