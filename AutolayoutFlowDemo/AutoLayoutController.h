//
//  AutoLayoutController.h
//  AutoLayout
//
//  Created by Nemo on 15/2/11.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BridgeView.h"
#import "TestView.h"
@interface AutoLayoutController : UIViewController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollwidthConstrant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstrants;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (strong, nonatomic) IBOutlet UIButton *animationButton;

@property (nonatomic, strong) IBOutlet BridgeView *xibView;

- (IBAction)animation:(id)sender;
@end
