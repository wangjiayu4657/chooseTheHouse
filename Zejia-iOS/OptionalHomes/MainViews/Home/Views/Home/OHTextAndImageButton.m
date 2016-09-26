//
//  OHTextAndImageButton.m
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHTextAndImageButton.h"

@implementation OHTextAndImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}
- (void)setButtomImage:(NSString *)buttomImage title:(NSString *)title{
    CGFloat titleWidth = [OHCommon getLabelWidthWith:title and:14*kAdaptationCoefficient];
    UIImage *image = [UIImage imageNamed:buttomImage];
    CGFloat imageWidth = image.size.width;
    titleWidth = titleWidth > (OHScreenW/3-30)?(OHScreenW/3-30):titleWidth;
    if (self.buttomLable==nil) {
        self.buttomLable = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-titleWidth-imageWidth)/2, 16*kAdaptationCoefficient, titleWidth+5, 16*kAdaptationCoefficient)];
        [self addSubview:self.buttomLable];
        
    }
    else{
        self.buttomLable.frame = CGRectMake((self.frame.size.width-titleWidth-imageWidth)/2, 16*kAdaptationCoefficient, titleWidth, 16*kAdaptationCoefficient);
        
    }
    if (self.buttomImage==nil) {
        self.buttomImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buttomLable.frame), 20*kAdaptationCoefficient, 12*kAdaptationCoefficient, 12*kAdaptationCoefficient)];
        [self addSubview:self.buttomImage];
    }
    else{
        self.buttomImage.frame = CGRectMake(CGRectGetMaxX(self.buttomLable.frame), 20*kAdaptationCoefficient, 12*kAdaptationCoefficient, 12*kAdaptationCoefficient);
        
    }
    self.buttomLable.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    self.buttomImage.image = [UIImage imageNamed:buttomImage];
    self.buttomLable.text = title;
    self.buttomLable.textColor = OHColor(40, 35, 35, 1.0);
}
- (void)setButtomImage:(NSString *)buttomImage imageFrame:(CGRect )imageFrame title:(NSString *)title titleFrame:(CGRect )titleFrame{
    self.buttomLable = [[UILabel alloc] initWithFrame:titleFrame];
    [self addSubview:self.buttomLable];
    self.buttomLable.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    self.buttomImage = [[UIImageView alloc]initWithFrame:imageFrame];
    [self addSubview:self.buttomImage];
    
    self.buttomImage.image = [UIImage imageNamed:buttomImage];
    self.buttomLable.text = title;
    self.buttomLable.textColor = [UIColor whiteColor];
}

@end
