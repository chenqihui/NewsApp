//
//  ScrollContainerViewController.h
//  WYApp
//
//  Created by chen on 14/7/15.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  目前只支持三个页面都有的情况，缺少左右页面或者其中之一还没有处理
 */
@interface ScrollContainerViewController : UIViewController

//初始化左右中三个页面
- (void)addViewControllerWithMain:(UIViewController *)mainVC left:(UIViewController *)leftVC right:(UIViewController *)rightVC;

//设置左右两边缩进大小，由于带有缩小，所以正常x坐标是无法达到希望的位置（这个自己设置下就会明白）
@property (nonatomic, assign) float nLeftW;
@property (nonatomic, assign) float nRightW;

//展开左边菜单
- (void)showLeft;
//展开右边菜单
- (void)showRight;
//当到达左右边缘时，设置是否可以滚动（即拉拽效果）
//主要用于展开左右两边菜单时，不能再继续滚动
- (void)setScrollEnabled:(BOOL)bScroll;

@end
