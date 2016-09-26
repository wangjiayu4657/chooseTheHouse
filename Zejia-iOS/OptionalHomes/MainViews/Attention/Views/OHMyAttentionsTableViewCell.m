//
//  OHMyAttentionsTableViewCell.m
//  OptionalHome
//
//  Created by lujun on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHMyAttentionsTableViewCell.h"

@implementation OHMyAttentionsTableViewCell

- (void)OHMyAttentionsTableViewCellConfigWithWithModel:(OHMyAttentionsModel *)model IndexPath:(NSIndexPath *)indexpath {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 10*kAdaptationCoefficient, 120*kAdaptationCoefficient, 90*kAdaptationCoefficient)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbUrl] placeholderImage:[UIImage imageNamed:@"follow_pic"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    [self.contentView addSubview:iconImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, 10*kAdaptationCoefficient, OHScreenW-(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient), 30*kAdaptationCoefficient)];
    nameLabel.text = model.name;
    nameLabel.textColor = OHColor(51, 51, 51, 1.0);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [self.contentView addSubview:nameLabel];
    
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), CGRectGetWidth(nameLabel.frame), 20*kAdaptationCoefficient)];
    yearLabel.text = [NSString stringWithFormat:@"建筑年代：%@",model.buildAge];
    yearLabel.textColor = OHColor(153, 153, 153, 1.0);
    yearLabel.textAlignment = NSTextAlignmentLeft;
    yearLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    [self.contentView addSubview:yearLabel];
    
    UILabel *districtLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(yearLabel.frame), CGRectGetMaxY(yearLabel.frame), CGRectGetWidth(yearLabel.frame), 20*kAdaptationCoefficient)];
    districtLabel.text = [NSString stringWithFormat:@"%@  %@",model.region,model.plate];
    districtLabel.textColor = OHColor(153, 153, 153, 1.0);
    districtLabel.textAlignment = NSTextAlignmentLeft;
    districtLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    [self.contentView addSubview:districtLabel];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(districtLabel.frame), CGRectGetMaxY(districtLabel.frame), CGRectGetWidth(districtLabel.frame), 20*kAdaptationCoefficient)];
    priceLabel.text = [NSString stringWithFormat:@"均价: %@元/m²", model.avgPrice];
    priceLabel.textColor = OHColor(153, 153, 153, 1.0);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    [self.contentView addSubview:priceLabel];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:OHColor(245, 119, 0, 1.0) range:[[str string] rangeOfString:[NSString stringWithFormat:@"%@元/m²", model.avgPrice]]];
    [str addAttribute:NSFontAttributeName value:[OHFont systemFontOfSize:14*kAdaptationCoefficient] range:[[str string] rangeOfString:[NSString stringWithFormat:@"%@元/m²", model.avgPrice]]];
    priceLabel.attributedText = str;
    
    
    //分隔线
    [self initLineViewWithFrame:CGRectMake(0, 114*kAdaptationCoefficient-1, OHScreenW, 1)];
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
