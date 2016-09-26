//
//  OHSettingTableViewCell.m
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSettingTableViewCell.h"

@implementation OHSettingTableViewCell

- (void)OHSettingTableViewCellConfigWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 2) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 0, 200, 52*kAdaptationCoefficient)];
        titleLabel.textColor = OHColor(40, 35, 35, 1.0);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16*kAdaptationCoefficient];
        [self.contentView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5)*kAdaptationCoefficient, (52-16.5)*kAdaptationCoefficient/2.0, 16.5*kAdaptationCoefficient, 16.5*kAdaptationCoefficient)];
        arrowImageView.image = [UIImage imageNamed:@"currency_arrow_right"];
        [self.contentView addSubview:arrowImageView];
        
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                titleLabel.text = @"意见反馈";
                
                //分隔线1
                [self initLineViewWithFrame:CGRectMake(0, 0, OHScreenW, 1)];
                
                //分隔线2
                [self initLineViewWithFrame:CGRectMake(12*kAdaptationCoefficient, 52*kAdaptationCoefficient, OHScreenW-12*kAdaptationCoefficient, 1)];
            }
            else if (indexPath.row ==1) {
                
                titleLabel.text = @"关于我们";
                
                //分隔线3
                [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient-1, OHScreenW, 1)];
            }
        }
        else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                titleLabel.text = @"给择家评分";
                
                //分隔线1
                [self initLineViewWithFrame:CGRectMake(0, 0, OHScreenW, 1)];
                
                //分隔线2
                [self initLineViewWithFrame:CGRectMake(12*kAdaptationCoefficient, 52*kAdaptationCoefficient, OHScreenW-12*kAdaptationCoefficient, 1)];
            }
            else if (indexPath.row ==1) {
                
                titleLabel.text = @"清除缓存";
                
                UILabel *cacheSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(arrowImageView.frame)-100, 0, 100, 52*kAdaptationCoefficient)];
                cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                cacheSizeLabel.textColor = OHColor(153, 153, 153, 1.0);
                cacheSizeLabel.textAlignment = NSTextAlignmentRight;
                cacheSizeLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
                [self.contentView addSubview:cacheSizeLabel];
                
                //分隔线3
                [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient-1, OHScreenW, 1)];
            }
        }
    }
    else {
        
        //分隔线1
        [self initLineViewWithFrame:CGRectMake(0, 0, OHScreenW, 1)];
        
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, 52*kAdaptationCoefficient)];
        loginLabel.text = @"退出登录";
        loginLabel.textColor = OHColor(40, 35, 35, 1.0);
        loginLabel.textAlignment = NSTextAlignmentCenter;
        loginLabel.font = [UIFont systemFontOfSize:17*kAdaptationCoefficient];
        [self.contentView addSubview:loginLabel];
        
        //分隔线2
        [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient-1, OHScreenW, 1)];
    }
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
