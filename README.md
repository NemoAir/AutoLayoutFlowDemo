# AutoLayoutFlowDemo
AutoLayoutFlowDemo 
这个Demo主要用来展示约束到布局生效的过程。
并不针对约束的使用说明，是演示从约束到布局生效过程，通过约束来改变view的大小并产生动画改变。
同时也展示了 ScrollView 的正确约束使用方式，通过正确的约束使superView根据subviews的大小自动改变自己的frame。

#AutoLayoutController 类的内容
AutoLayoutController类主要展示了约束到布局的过程，顺便对ScrollView使用了自动布局和动画改变bounds。

viewcontroller中和 “约束-布局-渲染” 过程有关的主要方法和流程。
```Objective-C 
1. -initWithNibName 
  如果使用 StoryBoard 加载 ViewController ，则会直接调用 -initWithCoder 方法，而不会调用该方法。
  而通过加载 Xib 或者直接 -init 都会调用这个方法
2. -loadView
3. -viewDidLoad
  这里需要注意，在 iOS8 中，Xib文件中的view在这个阶段并不会加载到self.view的层次结构中。所以这
  个时候如果进行布局或者约束的生成和改变时无效的，而 iOS7  这个时候已经将 xib 里的 view 加到 self.view 的层次结构中
4. -viewWillAppear
5. -viewWillLayoutSubviews 
	这个方法会使self.view 调用layoutSubviews
6. [self.view layoutSubviews]
	调用了这个方法后，就会对 self.view 的 subviews 也调用 
	-updateConstraint
	方法，更新约束。在iOS8中，这个时候Xib中加载的view已经加入到self.view的层次结构中
8. [self updateConstranits];  
9. -viewDidLayoutSubviews
10. -viewDidAppear
11. -viewWillDisappear
12. -viewDidDisappear
13. -dealloc
 ```
首先自动布局发生的顺序是：
```
1.更新约束。
2.依赖约束系统计算出subviews的frame开始布局。
3.根据计算出的frame重新在屏幕上渲染。
```
在第2步的过程中可能重复触发第一步的约束更新操作，也就是在发生布局的时候可能还会触发更新约束的过程，高级的约束可能会出现这种情况，同时这种情况要注意不要形成死循环。
所以不能在第一步的约束更新操作中配置布局，例如调用
```Objective-C 
[self.view layoutIfNeeded]
```
来触发布局，这样可能会造成死循环。

#约束和布局的几个相关方法介绍
约束和布局的几个相关方法
```Objective-C 
1） [self.view setNeedsUpdateConstraints]
2） [self.view updateConstraintsIfNeeded]
3） [self.view setNeedsLayout]
4） [self.view layoutIfNeeded]
5)  [self.view setNeedsDisplay] 
```
 5)
 ```Objective-C 
 [self.view setNeedsDisplay] 这个方法和渲染有关，但是因为名字比较相似，我自己也混淆过，所以也一起说明下
 ```
 
 
 1) 
 ```Objective-C 
 [self.view setNeedsUpdateConstraints] 告诉约束系统view约束系统需要更新
 ```
 
 
 2）
 ```Objective-C 
 [self.view updateConstraintsIfNeeded]  立即更新view的约束
 ```

 
 这两个方法都是针对约束的操作方法。
 1）调用后告诉系统该view上的约束有更新，系统相当于有一个需要更新该view的标记flag，在下次
  进行计算或更新约束的时候.比如调用了2）就会调用viewcontrollerde  
  ```
  -updateViewConstraints
  ```
 但是这里有个坑需要注意。如果单独调用2）不一定会触发updateViewConstraints。
 因为 1）和 2）的实现类似下面布局更新方法的实现原理：
```Objective-C 
-(void)layoutIfNeeded {
  if (self._needsLayout) {
      UIView *sv = self.superview;
      if (sv._needsLayout) {
         [sv layoutIfNeeded];
      } else {
         [self layoutSubviews];
      }
  }
}
``` 


所以在更新约束的时候要 1）、 2）一起调用才能保证约束立刻被计算。
而且在任何地方对约束进行改变都会触发 1）的方法。
1）会调用2），2）又会触发 viewController的-updateViewConstraints方法，所以最后还可以在updateViewConstraints方法中最后配置一
次布局约束。但是我经过考虑，在需要触发约束改变的地方就直接改变约束会比较好。-updateViewConstraints 方法作为最后一步来补
救约束的选择。
同时约束的计算是从subview到superview的，这点和布局、渲染到屏幕的过程刚好相反。布局和渲染是从superview到subview中来进行的。

3）
```Objective-C 
[self.view setNeedsLayout] 标记view布局需要更新
```


4）
```Objective-C 
[self.view layoutIfNeeded] 立即更新view的布局
```


这两个方法是对布局进行改变的方法。他们合作的原理和1）、2）一样。3）负责标记需要布局改变，4）来触发
 ```Objective-C 
-layoutSubviews
```
但是调用 4) 的时候会判断是 否需要更新布局的 flag ，就是如果没有调用3）有可能4）并不会触发layoutSubviews。所以在实践中3）、4）也最好一
起使用，才能保证布局更新。这两个方法加入动画块就可以实现动画布局的效果。
比如你更新好约束后，这样调用：
```Objective-c
[UIView animateWithDuration:0.4 animations:^{
      [self.view setNeedsLayout];
      [self.view layoutIfNeeded];
}];
```
就可以动画改变布局。

     在viewcontroller中调用 3）和4）会重新触发viewWillLayoutSubviews，viewDidLayoutSubviews的过程，所以最好不要在这两个方法
     中加入布局的代码，应该完全依靠约束来保证布局，因为这两个方法在每次布局过程中都会被调用。

 同时布局frame的计算过程是从 superview 到 subview 的。而 -layoutSubviews 方法被触发后，会对该 view 的 subviews 进行
 ```Objective-C 
 -layoutIfNeeded 
 ```
  的递归操作。所以布局 frame 的计算是从 superView 到 subView 的。

    这里要明白，-layoutSubviews方法是最后一步可以补救布局修改frame的地方，最好在前面的步骤中就通过约束来完成布局
    ，除非万不得已才在自定义 view中重载-layoutSubview方法来完成最后一步布局。这所有的过程都是前后逻辑依赖的，frame
    的计算会依赖约束的计算，所以在布局的阶段可能会重新调用约束的计算的阶段。当最后布局完成后就是屏幕从上到下的渲染
    过程。这个过程涉及到的就是下面的 5）。

5) 调用后会触发view的 -drawRect 方法重绘，和布局没有关系。调用这个方法后 -drawRect 方法何时调用系统决定，开发者则不用操心，系统对重绘有自己的优化方法。
实时绘图需要在 
 ```Objective-C 
-touchBegan 
```
方法中调用 5）来实时刷新屏幕。

所以实践中的情况是：
```
a.如果手动直接改变了约束，直接调用布局更新方法 3）即可，因为 3）调用后在触发布局的时候会自动调用约束计算方法 2）计算最新的约束。

b.如果在某些情况下在重载 -updateViewConstraints 的方法中需要改变约束，调用 1），而且大多数情况下接着调用 3）。

c.如果在改变约束后需要马上重新布局，那么在上述的操作后立马调用 4）来使新的约束生效。在动画 block 中调用就会产生动画效果。
```
#AutoSizeViewController 类
AutoSizeViewController 类主要是演示一个superView正确设置好约束后如何使用约束系统根据subviews的内容来改变自身的大小。同时说明了相关方法。

在没有自动布局之前，UIView包括子类比如UILabel这些可以通过重写-sizeThatFits:方法来返回正确的自定义UIView的大小，这个方法只计算并不会改变view的size。使用时调用 -sizeToFit方法，然后这个方法会调用-sizeThatFits返回的size大小来重新设置view的size.

在使用自动布局后，UIView中多了一个方法，- systemLayoutSizeFittingSize 通过这个方法，根据view里面的约束条件，返回系统计算出的view的size大小。这样只要设置好view里面subviews的约束关系，就可以直接得到view的size。
同时有两个参数： UILayoutFittingCompressedSize 和 UILayoutFittingExpandedSize，分别返回满足约束的最小和最大可能size，一般使用前者。

同时UIView中还有一个- intrinsicContentSize 方法，也是自动布局用来计算view的size。默认的实现是返回（-1，-1），自定义的view可以重载这个方法返回正确的size，重载该方法的view才不会返回（-1，-1）。如果实现了约束，并没有重载该方法还是会默认返回（-1，-1）。但-systemLayoutSizeFittingSize方法会正确的size。
通过这几个方法就可以实现根据内容自动改变大小的view。在cell size的计算中应该会有非常大的帮助，不用再去手动计算。

#XXNibBridge
XXNibBridge 类是sunnyxxx 写一个如何非常简单的实现Xib的动态桥接。这篇blog有详细的说明，使用了一些RunTime的特性来实现。
BridgeView 类展示了使用方法，非常简单。在Xib与代码结合使用的时候会非常高效。

[XXNibBridge blog地址](http://blog.sunnyxx.com/2014/07/01/ios_ib_bridge/)<br/>

[XXNibBride GitHub](https://github.com/sunnyxx/XXNibBridge)<br/>
