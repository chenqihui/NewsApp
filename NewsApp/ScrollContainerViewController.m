//
//  ScrollContainerViewController.m
//  WYApp
//
//  Created by chen on 14/7/15.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ScrollContainerViewController.h"

typedef NS_ENUM(NSUInteger, MoveDirectionTag)
{
    kMoveDirectionTag_right2left,
    kMoveDirectionTag_left2right
};

@interface ScrollContainerViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_mainScrollV;
    
    UIViewController *_leftVC;
    UIViewController *_rightVC;
    UIViewController *_mainVC;
    
    int _scrollPageCount;
    float _width;
    
    float _startPointX;
    MoveDirectionTag _moveDir;
    
    UIView *_maskV;
    UITapGestureRecognizer *_tapGestureRec;
    
    BOOL _bShowingLeft;
    BOOL _bShowingRight;
}

@end

@implementation ScrollContainerViewController

@synthesize nRightW = _nRightW;
@synthesize nLeftW = _nLeftW;

- (void)viewDidLoad
{
    _width = self.view.frame.size.width;
    _startPointX = _width;
    
    _mainScrollV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_mainScrollV setPagingEnabled:YES];
    [_mainScrollV setShowsHorizontalScrollIndicator:NO];
    [_mainScrollV setBounces:NO];
    _mainScrollV.delegate = self;
    [self.view addSubview:_mainScrollV];
    
    _nLeftW = 300;
    _nRightW = 200;
}

- (void)addViewControllerWithMain:(UIViewController *)mainVC left:(UIViewController *)leftVC right:(UIViewController *)rightVC
{
    _scrollPageCount = 0;
    float width = _width;
    float height = self.view.frame.size.height;
    if (leftVC != nil)
    {
        _leftVC = leftVC;
        [_leftVC.view setFrame:CGRectMake(width * _scrollPageCount, 0, width, height)];
        [_mainScrollV addSubview:_leftVC.view];
        _scrollPageCount++;
    }
    
    {
        if (mainVC != nil)
            _mainVC = mainVC;
        else
        {
            mainVC = [[UIViewController alloc] init];
            [mainVC.view setBackgroundColor:[UIColor whiteColor]];
        }
        
        [_mainVC.view setFrame:CGRectMake(width * _scrollPageCount, 0, width, height)];
        [_mainScrollV addSubview:_mainVC.view];
        _scrollPageCount++;
        
        _maskV = [[UIView alloc] initWithFrame:_mainVC.view.bounds];
        [_maskV setBackgroundColor:[UIColor blackColor]];
        [_maskV setAlpha:0.3];
        _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
        [_maskV addGestureRecognizer:_tapGestureRec];
        [_maskV setHidden:YES];
        [_mainVC.view addSubview:_maskV];
    }
        
    if (rightVC != nil)
    {
        _rightVC = rightVC;
        [_rightVC.view setFrame:CGRectMake(width * _scrollPageCount, 0, width, height)];
        [_mainScrollV insertSubview:_rightVC.view belowSubview:_mainVC.view];
        _scrollPageCount++;
    }
    
    [_mainScrollV setContentSize:CGSizeMake(width * _scrollPageCount, _mainScrollV.frame.size.height)];
    [_mainScrollV scrollRectToVisible:_mainVC.view.frame animated:NO];
}

- (void)closeSideBar
{
    [UIView animateWithDuration:0.4 animations:^
     {
         _mainVC.view.transform = CGAffineTransformMakeScale(1, 1);
         [_mainVC.view setFrame:CGRectMake(_width, _mainVC.view.frame.origin.y, _mainVC.view.frame.size.width, _mainVC.view.frame.size.height)];
         [_mainScrollV scrollRectToVisible:_mainVC.view.frame animated:NO];
         
         if (_bShowingLeft)
         {
             [_leftVC.view setFrame:CGRectMake(_width, _leftVC.view.frame.origin.y, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height)];
         }else if (_bShowingRight)
         {
             [_rightVC.view setFrame:CGRectMake(_width, _rightVC.view.frame.origin.y, _rightVC.view.frame.size.width, _rightVC.view.frame.size.height)];
         }
    }completion:^(BOOL finished)
     {
         _bShowingLeft = NO;
         _bShowingRight = NO;
         [_maskV setHidden:YES];
    }];
}

- (void)showLeft
{
//    CGFloat value = (0-_width)/_width;
//    CGFloat scale = fabs(cos(fabs(value)*M_PI/4));
//    float xx = fabs(value)*(_width/3*2);

    [_leftVC.view setFrame:CGRectMake(_width, _leftVC.view.frame.origin.y, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height)];
    [UIView animateWithDuration:0.4 animations:^
     {
//         _mainVC.view.transform = CGAffineTransformMakeScale(scale, scale);
//         [_mainVC.view setFrame:CGRectMake(xx, _mainVC.view.frame.origin.y, _mainVC.view.frame.size.width, _mainVC.view.frame.size.height)];
         [_mainScrollV scrollRectToVisible:CGRectMake(0, _leftVC.view.frame.origin.y, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height) animated:NO];
         
         [_leftVC.view setFrame:CGRectMake(0, _leftVC.view.frame.origin.y, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height)];

     }completion:^(BOOL finished)
     {
         _bShowingLeft = YES;
         _bShowingRight = NO;
         [_maskV setHidden:NO];
     }];
}

- (void)setScrollEnabled:(BOOL)bScroll
{
    [_mainScrollV setScrollEnabled:bScroll];
}

- (void)showRight
{
//    CGFloat value = _width/_width;
//    CGFloat scale = fabs(cos(fabs(value)*M_PI/4));
//    float xx = fabs(value)*(_width/3*2) + _width;
    
    [_rightVC.view setFrame:CGRectMake(_width, _rightVC.view.frame.origin.y, _rightVC.view.frame.size.width, _rightVC.view.frame.size.height)];
    [UIView animateWithDuration:0.4 animations:^
     {
//         _mainVC.view.transform = CGAffineTransformMakeScale(scale, scale);
//         [_mainVC.view setFrame:CGRectMake(xx, _mainVC.view.frame.origin.y, _mainVC.view.frame.size.width, _mainVC.view.frame.size.height)];
         [_mainScrollV scrollRectToVisible:CGRectMake(_width*2, _rightVC.view.frame.origin.y, _rightVC.view.frame.size.width, _rightVC.view.frame.size.height) animated:NO];
         
         [_rightVC.view setFrame:CGRectMake(_width*2, _rightVC.view.frame.origin.y, _rightVC.view.frame.size.width, _rightVC.view.frame.size.height)];
         
     }completion:^(BOOL finished)
     {
         _bShowingLeft = NO;
         _bShowingRight = YES;
         [_maskV setHidden:NO];
     }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    _startPointX = scrollView.contentOffset.x;
    [_maskV setHidden:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _bShowingLeft = NO;
    _bShowingRight = NO;
    if (scrollView.contentOffset.x == 0)
    {
        _bShowingLeft = YES;
        [_maskV setHidden:NO];
    }else if (scrollView.contentOffset.x == _width*2)
    {
        _bShowingRight = YES;
        [_maskV setHidden:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
//    if ((offset - _startPointX) > 0)
//        _moveDir = kMoveDirectionTag_left2right;
//    else
//        _moveDir = kMoveDirectionTag_right2left;
    
    CGFloat value = (offset-_width)/_width;
    CGFloat scale = fabs(cos(fabs(value)*M_PI/4));
    
    _mainVC.view.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (_scrollPageCount == 3)
    {
        if (offset < _width)
        {
            [_rightVC.view setHidden:YES];
            [_leftVC.view setHidden:NO];
            [_leftVC.view setFrame:CGRectMake(offset, _leftVC.view.frame.origin.y, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height)];
            
            float xx = 0;
//            switch (_moveDir)
//            {
//                case kMoveDirectionTag_right2left:
//                {
//                    CGFloat value = (offset-_width)/_width;
//                    xx = fabs(value)*(_width/3*2) + offset;
//                    break;
//                }
//                case kMoveDirectionTag_left2right:
//                {
////                    xx = (_width - offset)/3*2;//fabs(offset/3*2);
//                    CGFloat value = (offset-_width)/_width;
//                    xx = fabs(value)*(_width/3*2) + offset;
//                    break;
//                }
//            }
            CGFloat value = (offset-_width)/_width;
//            xx = fabs(value)*(_width/3*2) + offset;
            xx = fabs(value)*(_nLeftW)*scale + offset;
            [_mainVC.view setFrame:CGRectMake(xx, _mainVC.view.frame.origin.y, _mainVC.view.frame.size.width, _mainVC.view.frame.size.height)];
        }else if (offset > _width)
        {
            [_rightVC.view setHidden:NO];
            [_leftVC.view setHidden:YES];
            [_rightVC.view setFrame:CGRectMake(offset, _rightVC.view.frame.origin.y, _rightVC.view.frame.size.width, _rightVC.view.frame.size.height)];
            
            CGFloat value = (offset-_width)/_width;
//            float xx = fabs(value)*(-_width/3*1) + offset;
            float xx = fabs(value)*(-_width+_nRightW)*scale + offset;
            
            [_mainVC.view setFrame:CGRectMake(xx, _mainVC.view.frame.origin.y, _mainVC.view.frame.size.width, _mainVC.view.frame.size.height)];
        }
    }
//    _startPointX = offset;
}

@end
