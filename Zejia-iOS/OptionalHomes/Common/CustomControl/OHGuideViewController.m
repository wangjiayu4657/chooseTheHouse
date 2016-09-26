//
//  OHGuideViewController.m
//  OptionalHome
//
//  Created by haili on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHGuideViewController.h"
#import "OHPageControl.h"
@implementation OHGuideViewController
{
    NSArray *array;
    OHPageControl *_pageControl;                 //页面控制器

}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    scrollView
    CGRect frame = CGRectMake(0, 0, OHScreenW, OHScreenH);
    _myScrollView = [[UIScrollView alloc] initWithFrame:frame] ;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.delegate = self;
    _myScrollView.bounces = NO;
    [self.view addSubview:_myScrollView];
//    imageView
   _count = 3;
    for (int i = 0; i < _count; i++)
    {
        CGRect frame = {OHScreenW * i, 0, OHScreenW, OHScreenH};
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if (OHScreenH==480) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"lead%i_4s",i]];
        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"lead%i",i]];
        }

        imageView.userInteractionEnabled = YES;
        if (i == _count-1)
        {
            UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
            leftSwipeGestureRecognizer.delegate = self;
            leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            [_myScrollView addGestureRecognizer:leftSwipeGestureRecognizer];
        }
        [_myScrollView addSubview:imageView];
        
    }
    
    CGSize size = _myScrollView.contentSize;
    size.width = OHScreenW * _count;
    _myScrollView.contentSize = size;
    //分页控制器
    _pageControl = [[OHPageControl alloc] initWithFrame:CGRectMake(0, OHScreenH-30, OHScreenW, 10)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = _count;
    _pageControl.currentPage = 0; //当前页
    _pageControl.currentPageIndicatorTintColor = kOHThemeColor;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];

}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && _scrollPage==_count-1) {
        [self moveToLeftSide];
    }
    
}
#pragma mark - 图片向左效果
- (void)moveToLeftSide {
    [UIView animateWithDuration:0.2 //速度0.2秒
                     animations:^{//修改rView坐标
                         self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.view removeFromSuperview];
                     }];
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollPage = scrollView.contentOffset.x/OHScreenW;
    [_pageControl setCurrentPage:_scrollPage];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
