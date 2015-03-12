//
//  AutoResizeHeightController.h
//  AutolayoutFlowDemo
//
//  Created by Nemo on 15/3/12.
//  Copyright (c) 2015年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoResizeCell.h"
@interface AutoResizeCellHeightController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end
