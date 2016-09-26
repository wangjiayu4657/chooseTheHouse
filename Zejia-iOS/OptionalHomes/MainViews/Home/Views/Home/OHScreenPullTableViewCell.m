//
//  OHScreenPullTableViewCell.m
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHScreenPullTableViewCell.h"

@implementation OHScreenPullTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setCellWith:(OHScreenModel *)model andSelectStr:(NSString *)selectStr{
    //标题label
    if (self.titleLabel==nil) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 16*kAdaptationCoefficient, 200, 16*kAdaptationCoefficient)];
        self.titleLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        self.titleLabel.textColor = OHColor(40, 35, 35, 1.0);
        [self.contentView addSubview:self.titleLabel];
    }
    self.titleLabel.text = model.Item_Title;
    
    if ([model.Item_Title isEqualToString:selectStr]) {
        //选中的图片ImageView
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OHScreenW-44*kAdaptationCoefficient, 9*kAdaptationCoefficient, 20*kAdaptationCoefficient, 20*kAdaptationCoefficient)];
        [self.contentView addSubview:self.selectImageView];
        
        self.titleLabel.textColor = OHColor(251, 120, 0, 1.0);
        self.selectImageView.image = [UIImage imageNamed:@"home_sel_icon"];
    }
    else{
        self.titleLabel.textColor = OHColor(40, 35, 35, 1.0);
        self.selectImageView.image = [UIImage imageNamed:@""];
    }
}
@end
