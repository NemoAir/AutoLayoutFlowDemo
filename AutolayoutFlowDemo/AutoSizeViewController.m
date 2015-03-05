//
//  AutoSizeViewController.m
//  AutoLayout
//
//  Created by Nemo on 15/2/27.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import "AutoSizeViewController.h"

@interface AutoSizeViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *layoutView;

@end

@implementation AutoSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.firstLabel.text = @"   YES,calulate the size use these text.";
    self.firstLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) -100;
    self.secondLabel.preferredMaxLayoutWidth = self.firstLabel.preferredMaxLayoutWidth;\
    self.inputTextView.delegate = self;
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
    CGSize autoSize = [self.layoutView  systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.secondLabel.text = [NSString stringWithFormat:@"intrinsicSize = %@,LayoutSize = %@",NSStringFromCGSize(size),NSStringFromCGSize(autoSize)];
    [self.view invalidateIntrinsicContentSize];

}


- (IBAction)animationViewSize:(id)sender {
    [self.inputTextView resignFirstResponder];
    self.firstLabel.text = self.inputTextView.text;
    [self.view invalidateIntrinsicContentSize];
}
@end
