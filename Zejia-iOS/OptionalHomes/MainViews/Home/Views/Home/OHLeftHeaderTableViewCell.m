//
//  OHLeftHeaderTableViewCell.m
//  OptionalHome
//
//  Created by haili on 16/7/28.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLeftHeaderTableViewCell.h"
#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度

@implementation OHLeftHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWith:(NSString *)headerUrl andName:(NSString *)name{
    //头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((OHScreenW-kMainPageDistance-84*kAdaptationCoefficient)/2, 32*kAdaptationCoefficient, 84*kAdaptationCoefficient, 84*kAdaptationCoefficient)];
    headerImageView.layer.cornerRadius = 84*kAdaptationCoefficient/2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.borderWidth = 1.0;
    headerImageView.layer.borderColor = OHColor(238, 238, 238, 1.0).CGColor;
    headerImageView.backgroundColor =[UIColor redColor];
    [self.contentView addSubview:headerImageView];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] completed:nil];
    UIImageView *boderView = [[UIImageView alloc] initWithFrame:CGRectMake((OHScreenW-kMainPageDistance-60*kAdaptationCoefficient)/2, 40*kAdaptationCoefficient, 100*kAdaptationCoefficient, 100*kAdaptationCoefficient)];
    boderView.layer.cornerRadius = 100*kAdaptationCoefficient/2;
    boderView.center = CGPointMake(CGRectGetMidX(headerImageView.frame), CGRectGetMidY(headerImageView.frame));
    boderView.layer.borderWidth = 1.0;
    boderView.layer.borderColor = OHColor(238, 238, 238, 1.0).CGColor;
    [self.contentView addSubview:boderView];
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(boderView.frame)+8*kAdaptationCoefficient, OHScreenW-100-48*kAdaptationCoefficient, 28*kAdaptationCoefficient)];
    nameLabel.text = name;
    nameLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = OHColor(40, 35, 35, 1.0);
    [self.contentView addSubview:nameLabel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
