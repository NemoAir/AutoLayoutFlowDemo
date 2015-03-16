//
//  AutoResizeHeightController.m
//  AutolayoutFlowDemo
//
//  Created by Nemo on 15/3/12.
//  Copyright (c) 2015年 Nemo. All rights reserved.
//

#import "AutoResizeCellHeightController.h"

@interface AutoResizeCellHeightController ()

@property (nonatomic, strong) AutoResizeCell *modelCell;
@end

@implementation AutoResizeCellHeightController

-(void)loadView{
    [super loadView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];

    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //通过IB设置的约束 需要用w-any h-any 才能正常使用自动布局计算高度
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AutoResizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AutoResizeCell class])];
    
    self.modelCell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AutoResizeCell class]) owner:nil options:nil][0];
    
    
//    [self.tableView registerClass:[AutoResizeCell class] forCellReuseIdentifier:NSStringFromClass([AutoResizeCell class])];
//    self.modelCell = [[AutoResizeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AutoResizeCell class])];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AutoResizeCell *cell = (AutoResizeCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoResizeCell class])];
    cell.contentLabel.text = @"adfalsdfjasldfjalsjdflasjdflasjdflasjdflasjdfassdfasdfasdfasdf";
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    self.modelCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoResizeCell class])];
    self.modelCell.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelCell.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelCell.contentLabel.text = @"adfalsdfjasldfjalsjdflasjdflasjdflasjdflasjdfassdfasdfasdfasdf";

    [self.modelCell setNeedsUpdateConstraints];
    [self.modelCell updateConstraintsIfNeeded];
    self.modelCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.modelCell.bounds));

    [self.modelCell setNeedsLayout];
    [self.modelCell layoutIfNeeded];
    
    CGFloat height = [self.modelCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"%@ cell height = %@",@(indexPath.row).stringValue,@(height).stringValue);
    return height + 1;

}

@end
