//
//  OHRightImageButton.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHRightImageButton.h"

//static float const kImageToTextMargin = 15;

@implementation OHRightImageButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
    self.titleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    [self setTitleColor:[UIColor colorWithWhite:0.600 alpha:1.000] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.adjustsImageWhenHighlighted = NO;
    [self setImage:[UIImage imageNamed:@"home_btn_more_normal"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"home_btn_more_selected"] forState:UIControlStateSelected];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat kImageToTextMargin = self.width / 12;
    CGFloat sideMargin = self.width / 15;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, sideMargin * kAdaptationCoefficient, 0, 0);
    
    CGFloat titleLabelX = CGRectGetMaxX(self.titleLabel.frame) * kAdaptationCoefficient;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelX +  kImageToTextMargin * kAdaptationCoefficient, 0, 0);
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
