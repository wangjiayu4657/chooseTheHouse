//
//  OHSurroundingInformationCell.m
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSurroundingInformationCell.h"
#import "OHDetailModel.h"
#import "OHRightImageButton.h"
#import "OHDetailMapController.h"

static CGFloat const margin = 12 ;
static CGFloat const imageViewWH = 45;
static CGFloat const labelX = imageViewWH + margin + 8;
static CGFloat const startY = 50.5;
static CGFloat const viewHeight = 90;

@interface contentView : UIView

/** 标题*/
@property (strong , nonatomic) UIImageView *typeImageView;
/** 标题*/
@property (strong , nonatomic) UILabel *titleLabel;
/** 数量*/
@property (strong , nonatomic) UILabel *countLabel;
/** 内容*/
@property (strong , nonatomic) UILabel *contentLabel;
/**按钮*/
@property (strong , nonatomic) UIButton *button;

@end

@implementation contentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        CGFloat centerY = (imageViewWH - self.frame.size.height) / 2 * kAdaptationCoefficient;
        self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin * kAdaptationCoefficient, centerY, imageViewWH * kAdaptationCoefficient, imageViewWH * kAdaptationCoefficient)];
        [self addSubview:self.typeImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX * kAdaptationCoefficient, margin , 200 * kAdaptationCoefficient, 21 * kAdaptationCoefficient)];
        self.titleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        [self addSubview:self.titleLabel];
        
        CGFloat countLabelY = CGRectGetMaxY(self.titleLabel.frame);
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX * kAdaptationCoefficient, countLabelY,OHScreenW - labelX * kAdaptationCoefficient, 21 * kAdaptationCoefficient)];
        self.countLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.countLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        [self addSubview:self.countLabel];

        CGFloat contentLabelY = CGRectGetMaxY(self.countLabel.frame);
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX * kAdaptationCoefficient, contentLabelY, OHScreenW - labelX * kAdaptationCoefficient, 21 * kAdaptationCoefficient)];
        self.contentLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.contentLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        [self addSubview:self.contentLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.button];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end




@interface OHSurroundingInformationCell()

@property (strong , nonatomic) Singleton *singleton;

/**每个子 view 的 y 值*/
@property (assign , nonatomic) CGFloat viewStartY;

@end


@implementation OHSurroundingInformationCell

static OHSurroundingInformationCell *sourroundView = nil;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, 50 * kAdaptationCoefficient)];
        topView.backgroundColor = [UIColor whiteColor];
        topView.userInteractionEnabled = YES;
        [self addSubview:topView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"周边信息";
        label.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        label.font = [OHFont systemFontOfSize:17 * kAdaptationCoefficient];
        [label sizeToFit];
        label.x = margin;
        label.y = topView.height / 2.0 - label.height / 2.0;
        [topView addSubview:label];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat centerY = label.centerY;
        CGFloat rightButtonX = OHScreenW - 125 * kAdaptationCoefficient;
        rightButton.size = CGSizeMake( 128 * kAdaptationCoefficient, topView.height);
        rightButton.centerY = centerY;
        rightButton.x = rightButtonX;
        [rightButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:0.996 green:0.467 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"orange_arrow"] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [OHFont systemFontOfSize:16 * kAdaptationCoefficient];
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -22 * kAdaptationCoefficient, 0, 0);
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 98 * kAdaptationCoefficient, 0, 0);
        [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:rightButton];
        
        self.singleton = [Singleton shareSingleton];
        self.singleton.sectionHeaderViewHeight = 50 * kAdaptationCoefficient;
        self.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    }
    return self;
}


- (void)setModel:(OHDetailModel *)model {
    if (model.chi != 0) {
        contentView *subContentView = [[contentView alloc] init];
        subContentView.frame = CGRectMake(0, startY * kAdaptationCoefficient, OHScreenW, viewHeight * kAdaptationCoefficient);
        subContentView.typeImageView.image = [UIImage imageNamed:@"R_icon"];
        subContentView.titleLabel.text = @"吃";
        subContentView.countLabel.text = [NSString stringWithFormat:@"有%d个美食广场",model.chi];
        subContentView.contentLabel.text = model.chiName;
        subContentView.button.tag = 0;
        subContentView.button.frame = subContentView.bounds;
        [subContentView.button addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subContentView];
        self.viewStartY = CGRectGetMaxY(subContentView.frame);
    }
    if (model.wan != 0) {
        contentView *subContentView = [[contentView alloc] init];
        subContentView.frame = CGRectMake(0, self.viewStartY + 1 / 2.0, OHScreenW, viewHeight * kAdaptationCoefficient);
        subContentView.typeImageView.image = [UIImage imageNamed:@"P_icon"];
        subContentView.titleLabel.text = @"玩";
        subContentView.countLabel.text = [NSString stringWithFormat:@"有%d个休闲场所",model.wan];
        subContentView.contentLabel.text = model.chiName;
        subContentView.button.tag = 1;
        subContentView.button.frame = subContentView.bounds;
        [subContentView.button addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subContentView];
        self.viewStartY = CGRectGetMaxY(subContentView.frame);
    }
    if (model.xue != 0) {
        contentView *subContentView = [[contentView alloc] init];
        subContentView.frame = CGRectMake(0, self.viewStartY + 1 / 2.0, OHScreenW, viewHeight * kAdaptationCoefficient);
        subContentView.typeImageView.image = [UIImage imageNamed:@"Sc_icon"];
        subContentView.titleLabel.text = @"学";
        subContentView.countLabel.text = [NSString stringWithFormat:@"有%d个所学校/机构",model.xue];
        subContentView.contentLabel.text = model.chiName;
        subContentView.button.tag = 2;
        subContentView.button.frame = subContentView.bounds;
        [subContentView.button addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subContentView];
        self.viewStartY = CGRectGetMaxY(subContentView.frame);
    }
    if (model.mai != 0) {
        contentView *subContentView = [[contentView alloc] init];
        subContentView.frame = CGRectMake(0, self.viewStartY + 1 / 2.0, OHScreenW, viewHeight * kAdaptationCoefficient);
        subContentView.typeImageView.image = [UIImage imageNamed:@"Sh_icon"];
        subContentView.titleLabel.text = @"买";
        subContentView.countLabel.text = [NSString stringWithFormat:@"有%d个购物广场",model.mai];
        subContentView.contentLabel.text = model.chiName;
        subContentView.button.tag = 3;
        subContentView.button.frame = subContentView.bounds;
        [subContentView.button addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subContentView];
        self.viewStartY = CGRectGetMaxY(subContentView.frame);
    }
    if (model.yi != 0) {
        contentView *subContentView = [[contentView alloc] init];
        subContentView.frame = CGRectMake(0, self.viewStartY + 1 / 2.0, OHScreenW, viewHeight * kAdaptationCoefficient);
        subContentView.typeImageView.image = [UIImage imageNamed:@"H_icon"];
        subContentView.titleLabel.text = @"医";
        subContentView.countLabel.text = [NSString stringWithFormat:@"有%d个医疗机构",model.yi];
        subContentView.contentLabel.text = model.chiName;
        subContentView.button.tag = 4;
        subContentView.button.frame = subContentView.bounds;
        [subContentView.button addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subContentView];
        self.viewStartY = CGRectGetMaxY(subContentView.frame);
    }
    _model = model;
    self.singleton.sectionHeaderViewHeight = self.viewStartY;
}

- (void) rightButtonAction {
    OHDetailMapController *mapController = [[OHDetailMapController alloc] init];
    mapController.communityId = [NSString stringWithFormat:@"%@",self.communityId];
    mapController.type = 0+FoodPeripheryType;
    mapController.model = self.model;
    if ([self.window.rootViewController.childViewControllers[1] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController.childViewControllers[1];
        [controller pushViewController:mapController animated:YES];
    }
}


- (void)buttonClick:(UIButton *)button {
    OHDetailMapController *mapController = [[OHDetailMapController alloc] init];
    mapController.communityId = [NSString stringWithFormat:@"%@",self.communityId];
    mapController.type = button.tag+FoodPeripheryType;
    mapController.model = self.model;
    if ([self.window.rootViewController.childViewControllers[1] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController.childViewControllers[1];
        [controller pushViewController:mapController animated:YES];
    }
}

@end





























