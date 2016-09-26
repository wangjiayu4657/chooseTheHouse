//
//  OHHomeListTableViewCell.m
//  OptionalHome
//
//  Created by haili on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHomeListTableViewCell.h"
#import "OHTextAndImageButton.h"
#import "OHHomeListModel.h"
@implementation OHHomeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWith:(OHHomeListModel *)model{
    self.backgroundColor = OHColor(243, 243, 255, 1.0);
    self.contentView.userInteractionEnabled = YES;

    //背景view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, OHScreenW-2*(12*kAdaptationCoefficient), 260*kAdaptationCoefficient)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.layer.shouldRasterize = YES;
    backView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:backView];
    
    //社区图片
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 160*kAdaptationCoefficient)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.panoUrl] placeholderImage:[UIImage imageNamed:@"home_pic"] completed:nil];
    headImage.userInteractionEnabled = YES;
    [backView  addSubview:headImage];
    
    //关注按钮
    OHTextAndImageButton *attentionBtn = [[OHTextAndImageButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)-60*kAdaptationCoefficient, 0, 60*kAdaptationCoefficient, 60*kAdaptationCoefficient)];
    NSString *imageName;
    if ([model.isFollow integerValue]==1) {
        imageName = @"home_collect_selected_icon";
    }
    else if ([model.isFollow integerValue]==0)
    {
         imageName = @"home_collect_default_icon";
    }
    [attentionBtn setButtomImage:imageName imageFrame:CGRectMake(16*kAdaptationCoefficient, 14*kAdaptationCoefficient, 20*kAdaptationCoefficient, 20*kAdaptationCoefficient) title:@"" titleFrame:CGRectMake(4*kAdaptationCoefficient, 12*kAdaptationCoefficient, 44*kAdaptationCoefficient, 24*kAdaptationCoefficient)];
    attentionBtn.buttomLable.backgroundColor = OHColor(0, 0, 0, 0.5);

    attentionBtn.buttomLable.layer.masksToBounds = YES;
    attentionBtn.buttomLable.layer.cornerRadius = 24*kAdaptationCoefficient/2;
    attentionBtn.buttomLable.layer.shouldRasterize = YES;
    attentionBtn.buttomLable.layer.rasterizationScale = [UIScreen mainScreen].scale;
    attentionBtn.userInteractionEnabled = YES;
    [headImage addSubview:attentionBtn];
    [attentionBtn addTarget:self action:@selector(attenBtbClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    //标签的view
//    UIImageView *tagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headImage.frame)- 28*kAdaptationCoefficient, CGRectGetMaxX(headImage.frame), 28*kAdaptationCoefficient)];
//    UIImage *image = [UIImage imageNamed:@"home_shade_bg"];
//    UIImage *newImage=[image stretchableImageWithLeftCapWidth:28 topCapHeight:14];
//    tagView.image = newImage;
//    [headImage addSubview:tagView];
//    
//    //标签的label
//    NSArray *tagArr =[model.feature componentsSeparatedByString:@","];
//    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 0, CGRectGetWidth(tagView.frame), CGRectGetHeight(tagView.frame))];
//    tagLabel.text = [tagArr componentsJoinedByString:@"  "];
//    tagLabel.textColor = [UIColor whiteColor];
//    tagLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
//    [tagView addSubview:tagLabel];
    
    //白色背景
    UIView *backViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headImage.frame), CGRectGetWidth(headImage.frame), 100*kAdaptationCoefficient)];
    backViewTwo.backgroundColor = [UIColor whiteColor];
    [backView addSubview:backViewTwo];
    
    //社区名label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 12*kAdaptationCoefficient, CGRectGetWidth(backView.frame), 28*kAdaptationCoefficient)];
    nameLabel.text = model.communityName;
    nameLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    nameLabel.textColor = OHColor(40 ,35, 35, 1.0);
    [backViewTwo addSubview:nameLabel];
    
    //年代label
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, CGRectGetMaxY(nameLabel.frame),CGRectGetWidth(backView.frame), 24*kAdaptationCoefficient)];
    historyLabel.text = [NSString stringWithFormat:@"建筑年代：%@",model.buildAge];
    historyLabel.font =  [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    historyLabel.textColor = OHColor(153, 153, 153, 1.0);
    [backViewTwo addSubview:historyLabel];
    
    //均价label
    NSString *avgPriceStr = @"0";
    if (![model.avgPrice isEqual:[NSNull null]]) {
        avgPriceStr = [NSString stringWithFormat:@"%@",model.avgPrice];
    }
     NSString *labelStr = [NSString stringWithFormat:@"均价：%@元/㎡",avgPriceStr];
    CGFloat labelWidth = [OHCommon getLabelWidthWith:labelStr and:14*kAdaptationCoefficient];
   
    UILabel *avgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backView.frame)-labelWidth-12*kAdaptationCoefficient, CGRectGetMaxY(historyLabel.frame), labelWidth, 24*kAdaptationCoefficient)];
    avgPriceLabel.textColor = OHColor(255, 120, 0, 1.0);
    avgPriceLabel.font =  [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    [backViewTwo addSubview:avgPriceLabel];

    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:labelStr];
    NSRange redRange = NSMakeRange(0, 3);
    [noteStr addAttribute:NSForegroundColorAttributeName value:OHColor(153, 153, 153, 1.0) range:redRange];
    [avgPriceLabel setAttributedText:noteStr] ;

    //地址的label
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, CGRectGetMaxY(historyLabel.frame),CGRectGetWidth(backView.frame)-labelWidth-2*12*kAdaptationCoefficient, 24*kAdaptationCoefficient)];
    addressLabel.text = [NSString stringWithFormat:@"%@区  %@",model.region,model.plate];
    addressLabel.font =  [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    addressLabel.textColor = OHColor(153, 153, 153, 1.0);
    [backViewTwo addSubview:addressLabel];
    
    
}
-(void)attenBtbClick:(UIButton *)sender{
    __block UIButton *btn = (UIButton *)sender;
    self.attentionBlock(btn);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
