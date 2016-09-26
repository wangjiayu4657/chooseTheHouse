//
//  OHGuideViewController.h
//  OptionalHome
//
//  Created by haili on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHGuideViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *_myScrollView;
    NSInteger _scrollPage;
    NSInteger _count;//页数
    
}


@end
