//
//  OHHouseListTableViewCell.m
//  OptionalHome
//
//  Created by lujun on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHouseListTableViewCell.h"

@implementation OHHouseListTableViewCell

- (void)OHHouseListTableViewCellConfigWithWithModel:(OHHouseListModel *)model Site:(NSString *)site IndexPath:(NSIndexPath *)indexpath {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 20*kAdaptationCoefficient, 100*kAdaptationCoefficient, 75*kAdaptationCoefficient)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"follow_pic"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    [self.contentView addSubview:iconImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, 20*kAdaptationCoefficient, OHScreenW-(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient), 27*kAdaptationCoefficient)];
    nameLabel.text = model.title;
    nameLabel.textColor = OHColor(51, 51, 51, 1.0);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    [self.contentView addSubview:nameLabel];
    
    UILabel *layoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), CGRectGetWidth(nameLabel.frame), 24*kAdaptationCoefficient)];
    layoutLabel.text = [NSString stringWithFormat:@"%@  %@m²",model.layout, model.area];
    layoutLabel.textColor = OHColor(102, 102, 102, 1.0);
    layoutLabel.textAlignment = NSTextAlignmentLeft;
    layoutLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    [self.contentView addSubview:layoutLabel];
    
    UILabel *siteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(layoutLabel.frame), CGRectGetMaxY(layoutLabel.frame), CGRectGetWidth(layoutLabel.frame), 24*kAdaptationCoefficient)];
    if ([site isEqualToString:@"soufun"]) {
        siteLabel.text = @"房天下房源";
    }
    else if ([site isEqualToString:@"lianjia"]) {
        siteLabel.text = @"链家房源";
    }
    siteLabel.textColor = OHColor(102, 102, 102, 1.0);
    siteLabel.textAlignment = NSTextAlignmentLeft;
    siteLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    [self.contentView addSubview:siteLabel];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@万",model.price];
    CGSize priceSize = [priceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 27*kAdaptationCoefficient) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[OHFont systemFontOfSize:17*kAdaptationCoefficient]} context:nil].size;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-20*kAdaptationCoefficient-priceSize.width, CGRectGetMinY(nameLabel.frame), priceSize.width, 27*kAdaptationCoefficient)];
    priceLabel.text = priceStr;
    priceLabel.textColor = OHColor(254, 119, 0, 1.0);
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    [self.contentView addSubview:priceLabel];
    
    //均价
    NSString *avgPriceStr = [NSString stringWithFormat:@"%@元/m²",model.avgPrice];
    CGSize avgPriceSize = [avgPriceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 24*kAdaptationCoefficient) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[OHFont systemFontOfSize:12*kAdaptationCoefficient]} context:nil].size;
    UILabel *avgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-20*kAdaptationCoefficient-avgPriceSize.width, CGRectGetMaxY(nameLabel.frame), avgPriceSize.width, 24*kAdaptationCoefficient)];
    avgPriceLabel.text = avgPriceStr;
    avgPriceLabel.textColor = OHColor(153, 153, 153, 1.0);
    avgPriceLabel.textAlignment = NSTextAlignmentRight;
    avgPriceLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    [self.contentView addSubview:avgPriceLabel];
    
    //重置nameLabel/layoutLabel的frame
    nameLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, 20*kAdaptationCoefficient, CGRectGetMinX(priceLabel.frame)-(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient), 27*kAdaptationCoefficient);
    layoutLabel.frame = CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), CGRectGetMinX(avgPriceLabel.frame)-(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient);
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:OHColor(245, 119, 0, 1.0) range:[[str string] rangeOfString:[NSString stringWithFormat:@"%@元/m²", model.avgPrice]]];
    [str addAttribute:NSFontAttributeName value:[OHFont systemFontOfSize:14*kAdaptationCoefficient] range:[[str string] rangeOfString:[NSString stringWithFormat:@"%@元/m²", model.avgPrice]]];
    priceLabel.attributedText = str;
    
    
    //分隔线
    [self initLineViewWithFrame:CGRectMake(0, 115*kAdaptationCoefficient-1, OHScreenW, 1)];
}

//分隔线
- (void)initLineViewWithFrame:(CGRect)frame {
    
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = OHColor(238, 238, 238, 1.0);
    [self.contentView addSubview:lineView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
