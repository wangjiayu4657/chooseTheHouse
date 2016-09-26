//
//  OHCommunityBasicInformationCell.m
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHCommunityBasicInformationCell.h"
#import "OHDetailModel.h"

@interface OHCommunityBasicInformationCell()
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/**	容积率   (float)*/
@property (weak, nonatomic) IBOutlet UILabel *capacityRateLabel;

/**	绿化率   (float)*/
@property (weak, nonatomic) IBOutlet UILabel *greenRateLabel;

/**	建筑年代  (string)*/
@property (weak, nonatomic) IBOutlet UILabel *buildAgeLabel;

/**	房屋总数 (int)*/
@property (weak, nonatomic) IBOutlet UILabel *houseCountLabel;

/**	占地面积 (int)*/
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

/**	户均车位 (string)*/
@property (weak, nonatomic) IBOutlet UILabel *parkCountLabel;

@end

@implementation OHCommunityBasicInformationCell


+ (instancetype)showBasicInformationView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.basicInformationViewHeight = CGRectGetMaxY(self.bottomView.frame);
//    NSLog(@"basicInformationViewHeight == %f",self.basicInformationViewHeight);
}


- (void)setModel:(OHDetailModel *)model {
    self.capacityRateLabel.text = [NSString stringWithFormat:@"%@",model.capacityRate];
    self.capacityRateLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.greenRateLabel.text = [NSString stringWithFormat:@"%@", model.greenRate];
    self.greenRateLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.buildAgeLabel.text = model.buildAge;
    self.buildAgeLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.houseCountLabel.text = [NSString stringWithFormat:@"%zd",model.houseCount];
    self.houseCountLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.areaLabel.text = [NSString stringWithFormat:@"%zd㎡",model.area];
    self.areaLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.parkCountLabel.text = model.parkCount;
    self.parkCountLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
}

@end
