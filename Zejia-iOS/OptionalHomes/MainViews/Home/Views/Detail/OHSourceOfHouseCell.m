//
//  OHSourceOfHouseCell.m
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSourceOfHouseCell.h"
#import "OHDetailCellModel.h"

@interface OHSourceOfHouseCell()
//房源缩略图
@property (weak, nonatomic) IBOutlet UIImageView *logo;
//名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//户型
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
//面积
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
//均价
@property (weak, nonatomic) IBOutlet UILabel *avgPriceLabel;
//销售价格
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;

@end

@implementation OHSourceOfHouseCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OHDetailCellModel *)model {
    _model = model;    
    self.titleLabel.text = model.title;
    self.titleLabel.font = [OHFont systemFontOfSize:17 * kAdaptationCoefficient];
    self.layoutLabel.text = model.layout;
    self.layoutLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
//    self.siteNameLabel.text = ;
    
    [self.logo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"housing_pic"]];
    
    NSNumber *areaLabelNumber = [NSNumber numberWithFloat:model.area];
    self.areaLabel.text = [NSString stringWithFormat:@"%@㎡",areaLabelNumber];
    self.areaLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    
    NSNumber *avgPriceLabelNumber = [NSNumber numberWithFloat:model.avgPrice];
    self.avgPriceLabel.text = [NSString stringWithFormat:@"%@元/㎡",avgPriceLabelNumber];
    self.avgPriceLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    
    NSNumber *sellPriceLabelNumber = [NSNumber numberWithFloat:model.sellPrice];
    self.sellPriceLabel.text = [NSString stringWithFormat:@"%@万",sellPriceLabelNumber];
    self.sellPriceLabel.font = [OHFont systemFontOfSize:17 * kAdaptationCoefficient];
}



@end
