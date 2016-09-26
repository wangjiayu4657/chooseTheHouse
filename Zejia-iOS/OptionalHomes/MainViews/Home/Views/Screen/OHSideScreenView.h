//
//  OHSideScreenView.h
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHHomeViewController.h"

@interface OHSideScreenView : UIView

/** 点击确定按钮的回传*/
@property (strong , nonatomic) void(^completed)();


@end
