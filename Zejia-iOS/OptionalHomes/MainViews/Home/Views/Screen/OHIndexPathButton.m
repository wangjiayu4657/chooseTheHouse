//
//  OHIndexPathButton.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHIndexPathButton.h"

@implementation OHIndexPathButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.0 * kAdaptationCoefficient;
        self.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        self.layer.borderWidth = 1.5 * kAdaptationCoefficient;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
        self.backgroundColor =  [UIColor colorWithWhite:0.933 alpha:1.000];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.selected) {// 选中按钮时的状态风格
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        [self setTitleColor:[UIColor colorWithRed:1.000 green:0.467 blue:0.000 alpha:1.000] forState:UIControlStateSelected];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -3 * kAdaptationCoefficient, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5 * kAdaptationCoefficient, 0, 0);
        [self setImage:[UIImage imageNamed:@"screen_checkbox_icon"] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor whiteColor]];
//        NSLog(@"%@",self.currentTitle);
        
    }else{// 取消选中按钮时的状态风格
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithWhite:0.933 alpha:1.000]];
    }
}


@end
