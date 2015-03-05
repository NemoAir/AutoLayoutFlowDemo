//
//  AutoLayoutController.m
//  AutoLayout
//
//  Created by Nemo on 15/2/11.
//  Copyright (c) 2015年 Glow, Inc. All rights reserved.
//

#import "AutoLayoutController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface AutoLayoutController ()

@end

@implementation AutoLayoutController
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
    //1
    //通过SB 加载viewcontroller通过这个方法初始化
    
}
-(instancetype)init{
    self = [super init];
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
    //1
    //代码加载或者通过Xib加载viewcontroller 通过这个方法初始化
}
-(void)loadView{
    [super loadView];
    
    //2
    
    //这里我将viewcontroller的view用子类TestView在StoryBoard替换了，用来查看view的layoutSubviews调用时机
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //3
    
    /*这里需要注意，在iOS8中，Xib文件中的view在这个阶段并不会加载到self.view的层次结构中，就是说现在self.view并没有任何subview，可以打印self.view的subviews查看。
     所以这个时候对self.view上的任何subview进行布局或者约束的生成和改变是无效的。
     
     而iOS7 这个时候已经将xib里的view加到self.view的层次结构中，在这个地方进行约束修改是有效的。
     但建议到updateViewConstraints方法中进行初始化约束的修改。
     */
//    NSLog(@"self.view' subviews = %@",self.view.subviews);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //4
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //5
    //这个方法，会触发 [self.view layoutSubviews]方法
    //而self.view 调用 layoutSubviews 方法后，会递归触发所有 self.view 的subviews 的layoutIfNeeded方法，从而可能触发约束更新方法 updateConstraints
    
}
-(void)updateViewConstraints{
    
   
    //6
    
    //代码判断设备 设置约束 进行不同尺寸设备界面适配
    if (IS_IPHONE_4_OR_LESS) {
        //这个时候是3.5寸
        self.scrollViewBottomConstraint.constant = 120;
        
    }else{
        self.scrollViewBottomConstraint.constant = 170;
    }
    
    //viewcontroller 的约束更新方法。通过下面两个方法可以触发
    //    [self.view setNeedsUpdateConstraints];
    //    [self.view updateConstraintsIfNeeded];
    if (self.scrollwidthConstrant.constant == 240) {
        self.scrollwidthConstrant.constant = 260;
        self.bottomConstrant.constant = 20;
    }else{
        self.scrollwidthConstrant.constant = 240;
        self.bottomConstrant.constant = 100;
    }
    
   [super updateViewConstraints];//这个方法会触发self.view 的updateConstraints方法
}


-(void)viewDidLayoutSubviews{

    //7
    
    //在布局阶段 需要依赖前面的约束条件，可能会重新触发约束的计算。这个过程可能重复很多次，所以不要再约束更新的方法里面进行布局的设置，容易造成死循环
    
    //从约束到布局 最后到屏幕上显示出来的顺序是
    /*
    1.更新约束。
    2.根据约束，约束系统重新计算subviews的frame并布局。
    3.根据计算出的frame重新在屏幕上渲染。
    
    第二步可能会再调用第一步计算约束
     */
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //8

}

- (IBAction)animation:(id)sender {
    
    //    [self.view setNeedsUpdateConstraints];
    //该方法调用后，系统会在随后更新约束
    //触发-updateViewConstraints，
    
    
    //    [self.view updateConstraintsIfNeeded];
    //该方法调用后会让系统立即更新约束，但是更新前会判断约束更新的flag
    //所以先调用 [self.view setNeedsUpdateConstraints] ，确保会触发-updateViewConstraints约束更新。
    
    //    [self.view setNeedsLayout];
    //该方法调用后会将view的需要更新布局标记为YES，系统会在随后更新view的布局。
    //并触发view上的layoutSubviews方法。同时也会触发view上所有的subviews的layoutSubviews方法
    
    //    [self.view layoutIfNeeded];
    
    //该方法调用后会让系统立即更新布局，更新布局前会先判断布局是否需要更新，是否需要更新就是通过[self.view setNeedsLayout] 标记的。
    //如果需要才会真正触发view的布局更新。所以最好将这两个方法一起调用，保证视图布局更新。
    
    
    //控制约束更新的两个方法和控制布局更新的两个方法之间协作原理一样


    //加入动画块，动画布局
    [UIView animateWithDuration:0.4 animations:^{
                [self.view setNeedsUpdateConstraints];
        //单独使用 也会触发updateViewConstraints
        
                [self.view updateConstraintsIfNeeded];
        //单独使用这个方法并不会触发updateViewConstraints，而单独使用setNeedsUpdateConstraints 会触发约束更新的方法updateViewConstraints。
        
        //这里其实也可以不用调用约束更新的两个方法，而直接手动调用代码更新约束，在布局的时候同样会产生动画效果。这里调用这两个方法只是因为所有约束更新的代码都在updateViewConstraints方法里面。约束更新的方法可以写在任意你想要改变约束的时候。
        
        //比如将这段约束更新代码写在这里，不用调用约束更新代码同样会产生布局改变。

//        if (self.scrollwidthConstrant.constant == 260) {
//            self.scrollwidthConstrant.constant = 280;
//            self.bottomConstrant.constant = 200;
//        }else{
//            self.scrollwidthConstrant.constant = 260;
//            self.bottomConstrant.constant = 150;
//        }
        
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];//如果不先调用[self.view setNeedsLayout] 也不会触发视图布局更新
        
        //视图布局更新触发后，会再次先后调用viewWillLayoutSubviews 和 viewDidLayoutSubviews 所以最好不要在这两个方法爱里面做初始化的布局，因为可能会调用很多次。
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
