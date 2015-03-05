//
//  AutoSizeViewController.h
//  AutoLayout
//
//  Created by Nemo on 15/2/27.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoSizeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
- (IBAction)animationViewSize:(id)sender;
@end
