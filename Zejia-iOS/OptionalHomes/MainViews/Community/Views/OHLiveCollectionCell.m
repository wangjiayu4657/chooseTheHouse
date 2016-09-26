//
//  OHLiveCollectionCell.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLiveCollectionCell.h"
#import "OHFont.h"

@implementation OHLiveCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = OHColor(255, 255, 255, 1);
    }
    return self;
}

- (void)addSubView {
    self.img1View = [[UIImageView alloc] initWithFrame:CGRectMake((170 - 40)/2*kAdaptationCoefficient, 10*kAdaptationCoefficient, 40*kAdaptationCoefficient, 40*kAdaptationCoefficient)];
    self.img1View.image = [UIImage imageNamed:@"state_zhai_icon"];
    [self addSubview:self.img1View];
    
    self.titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.img1View.frame)+12*kAdaptationCoefficient, 150*kAdaptationCoefficient, 34*kAdaptationCoefficient)];
    self.titlLabel.textAlignment = NSTextAlignmentCenter;
    self.titlLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    self.titlLabel.tintColor = OHColor(51, 51, 51, 1);
    self.titlLabel.text = @"宅生活";
    [self addSubview:self.titlLabel];
    
    CGFloat height =[OHCommon getLabelHeightWith:_desc andWidth:150*kAdaptationCoefficient andFont:12*kAdaptationCoefficient];
    self.txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kAdaptationCoefficient, CGRectGetMaxY(self.titlLabel.frame)+5*kAdaptationCoefficient,150*kAdaptationCoefficient , height)];
    self.txtLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    self.txtLabel.tintColor = OHColor(153, 153, 153, 1);
    self.txtLabel.numberOfLines = 0;
    [self addSubview:self.txtLabel];
   
    self.img2View = [[UIImageView alloc] initWithFrame:CGRectMake((170-30)/2*kAdaptationCoefficient, (160+10)*kAdaptationCoefficient, 30*kAdaptationCoefficient, 30*kAdaptationCoefficient)];
    self.img2View.image = [UIImage imageNamed:@"state_check_btn"];
    [self addSubview:self.img2View];
    
    self.stausImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 170*kAdaptationCoefficient, 200*kAdaptationCoefficient)];
    self.stausImage.image = [UIImage imageNamed:@"new_state_checked"];
    self.stausImage.hidden = YES;
    [self addSubview:self.stausImage];
    
}

@end
