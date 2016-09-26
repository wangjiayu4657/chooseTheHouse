//
//  OHLeftTableViewCell.m
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLeftTableViewCell.h"

@implementation OHLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWithImage:(NSString *)imageName title:(NSString *)title{
    //分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, 1.0)];
    lineLabel.backgroundColor = OHColor(238, 238, 238, 1.0);
    [self.contentView addSubview:lineLabel];
    //图片
    if (self.titleImage==nil) {
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(24*kAdaptationCoefficient, 20*kAdaptationCoefficient, 25*kAdaptationCoefficient, 25*kAdaptationCoefficient)];
        [self.contentView  addSubview:self.titleImage];
    }
    self.titleImage.image = [UIImage imageNamed:imageName];
    
    //标题
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10*kAdaptationCoefficient, 20*kAdaptationCoefficient, 100, 25*kAdaptationCoefficient)];
        _titleLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = OHColor(40, 35, 35, 1.0);
        [self.contentView  addSubview:_titleLabel];
    }
    _titleLabel.text = title;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    NSLog(@"====0000=========");
}

@end
