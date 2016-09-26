//
//  OHButton.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHButton : UIButton

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;

- (OHButton *)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

@end
