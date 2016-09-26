//
//  OHButton.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHButton.h"

@interface OHButton ()

@property (nonatomic, strong) OHButton *button;

@end

@implementation OHButton

- (OHButton *)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
            _button = [[OHButton alloc] initWithFrame:frame];
            _button.backgroundColor = color;
            _button.layer.cornerRadius = 4;
            [self createSubViews];
    }
    return _button;
}

- (void)createSubViews {
//    CGFloat marX1 = 15;
//    CGFloat marX2 = 7;
    CGFloat KWITH = _button.frame.size.width;
    CGFloat KHEIGHT = KWITH *10/9;
    
    CGFloat iconW = 65 * kAdaptationCoefficient;
    CGFloat iconH = 60 * kAdaptationCoefficient;
    CGFloat iconX = (KWITH - iconW) * 0.5;
    CGFloat iconY = 15 * kAdaptationCoefficient;
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
//    [_button addSubview:self.imgView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconX, iconY + iconH, KWITH, KHEIGHT-27-iconH)];
    self.textLabel.font = [OHFont systemFontOfSize:16 * kAdaptationCoefficient];
    self.textLabel.textColor = OHColor(102, 102, 102, 1);
    [_button addSubview:self.textLabel];
}

@end
