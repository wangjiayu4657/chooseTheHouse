//
//  OHSideHeaderView.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSideHeaderView.h"

static float const kTitleButtonWidth = 280.f;
static float const kMoreButtonWidth  = 36 * 2;
//static float const kCureOfLineHight  = 0.5;
//static float const kCureOfLineOffX   = 16;

float const OHSideHeaderViewHeigt = 38;

@interface OHSideHeaderView()

@end

@implementation OHSideHeaderView

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

- (void)setTitle:(NSString *)title {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    if ([title containsString:@"("]) {
        CGFloat currange = [title rangeOfString:@"("].location;
        NSRange range = NSMakeRange(0, currange);
        [attrString setAttributes:@{NSFontAttributeName:[OHFont boldSystemFontOfSize:16 * kAdaptationCoefficient],NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
        [attrString setAttributes:@{NSFontAttributeName:[OHFont systemFontOfSize:14 * kAdaptationCoefficient],NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(currange, title.length - currange)];
        [self.titleButton setAttributedTitle:attrString forState:UIControlStateNormal];
        
    }else {
        [attrString setAttributes:@{NSFontAttributeName:[OHFont boldSystemFontOfSize:16 * kAdaptationCoefficient],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, title.length)];
        [self.titleButton setAttributedTitle:attrString forState:UIControlStateNormal];
    }
}

- (id)sharedInit {
    self.backgroundColor = [UIColor whiteColor];
    //头部左侧按钮仅修改self.titleButton的宽度,xyh值不变
    self.titleButton = [[UIButton alloc] init];
    self.titleButton.frame = CGRectMake(15 * kAdaptationCoefficient, 0, kTitleButtonWidth * kAdaptationCoefficient,  self.frame.size.height * kAdaptationCoefficient);
    [self.titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.titleButton];
    
    //头部右侧按钮仅修改self.moreButton的x,ywh值不变
    CGRect  moreBtnFrame = CGRectMake(self.width - kMoreButtonWidth - 15 * kAdaptationCoefficient, 0, kMoreButtonWidth * kAdaptationCoefficient, self.height * kAdaptationCoefficient);
    self.moreButton = [[OHRightImageButton alloc] initWithFrame:moreBtnFrame];
    [self.moreButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.moreButton setTitle:@"收起" forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    return self;
}

- (void)moreBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OHSideHeaderViewMoreButtonClick:)]) {
        [self.delegate OHSideHeaderViewMoreButtonClick:self.moreButton];
    }
}

@end