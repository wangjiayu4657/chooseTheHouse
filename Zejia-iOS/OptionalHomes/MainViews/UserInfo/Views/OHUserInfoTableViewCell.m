//
//  OHUserInfoTableViewCell.m
//  OptionalHome
//
//  Created by lujun on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHUserInfoTableViewCell.h"

@implementation OHUserInfoTableViewCell

- (void)OHUserInfoTableViewCellConfigWithUserInfo:(OHUserInfoModel *)userInfoModel IndexPath:(NSIndexPath *)indexPath {

    UILabel *titleLabel = nil;
    UIImageView *arrowImageView = nil;
    if ((indexPath.section == 0 && indexPath.row != 0) || (indexPath.section == 1)) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 0, 200, 52*kAdaptationCoefficient)];
        titleLabel.textColor = OHColor(40, 35, 35, 1.0);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16*kAdaptationCoefficient];
        [self.contentView addSubview:titleLabel];
    }
    
    if ((indexPath.section == 0 && indexPath.row != 0) || (indexPath.section == 1 && indexPath.row != 0)) {
        
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5)*kAdaptationCoefficient, (52-16.5)*kAdaptationCoefficient/2.0, 16.5*kAdaptationCoefficient, 16.5*kAdaptationCoefficient)];
        arrowImageView.image = [UIImage imageNamed:@"currency_arrow_right"];
        [self.contentView addSubview:arrowImageView];
    }
    else {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+150)*kAdaptationCoefficient, 0, 150*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            phoneLabel.text = userInfoModel.mobile;
            phoneLabel.textColor = OHColor(153, 153, 153, 1.0);
            phoneLabel.textAlignment = NSTextAlignmentRight;
            phoneLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:phoneLabel];
        }
    }
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            self.contentView.backgroundColor = kButtonEnableClick_BackgroundColor;
            
            UIImageView *avaterImageView = [[UIImageView alloc] initWithFrame:CGRectMake((OHScreenW-108*kAdaptationCoefficient)/2.0, (150-108)/2.0*kAdaptationCoefficient, 108*kAdaptationCoefficient, 108*kAdaptationCoefficient)];
            [avaterImageView sd_setImageWithURL:[NSURL URLWithString:userInfoModel.photoUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
            avaterImageView.layer.cornerRadius = 108*kAdaptationCoefficient/2.0;
            avaterImageView.clipsToBounds = YES;
            avaterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            avaterImageView.layer.borderWidth = 4*kAdaptationCoefficient;
            [self.contentView addSubview:avaterImageView];
        }
        else if (indexPath.row == 1) {
            
            titleLabel.text = @"昵称";
            
            UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5+200)*kAdaptationCoefficient, 0, 200*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            nicknameLabel.text = userInfoModel.nickname;
            nicknameLabel.textColor = OHColor(153, 153, 153, 1.0);
            nicknameLabel.textAlignment = NSTextAlignmentRight;
            nicknameLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:nicknameLabel];
            
            //分隔线
            [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient-1, OHScreenW, 1)];
        }
        else if (indexPath.row == 2) {
            
            titleLabel.text = @"密码";
            
            UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5+200)*kAdaptationCoefficient, 0, 200*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            passwordLabel.text = @"* * * * * *";
            passwordLabel.textColor = OHColor(153, 153, 153, 1.0);
            passwordLabel.textAlignment = NSTextAlignmentRight;
            passwordLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:passwordLabel];
            
            //分隔线
            [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient, OHScreenW, 1)];
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            titleLabel.text = @"手机";
            
            //分隔线
            [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient, OHScreenW, 1)];
        }
        else if (indexPath.row == 1) {
            titleLabel.text = @"微信";
            
            UILabel *bindStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5+200)*kAdaptationCoefficient, 0, 200*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            if ([OHCommon isEmptyOrNull:userInfoModel.weixin]) {
                
                bindStatusLabel.text = @"未绑定";
                bindStatusLabel.textColor = OHColor(153, 153, 153, 1.0);
            }
            else {
                self.userInteractionEnabled = NO;
                bindStatusLabel.text = @"已绑定";
                bindStatusLabel.textColor = OHColor(255, 119, 0, 1.0);
            }
            bindStatusLabel.textAlignment = NSTextAlignmentRight;
            bindStatusLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:bindStatusLabel];
            
            //分隔线
            [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient, OHScreenW, 1)];
        }
        else if (indexPath.row == 2) {
            titleLabel.text = @"QQ";
            
            UILabel *bindStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5+200)*kAdaptationCoefficient, 0, 200*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            if ([OHCommon isEmptyOrNull:userInfoModel.qq]) {
                
                bindStatusLabel.text = @"未绑定";
                bindStatusLabel.textColor = OHColor(153, 153, 153, 1.0);
            }
            else {
                self.userInteractionEnabled = NO;
                bindStatusLabel.text = @"已绑定";
                bindStatusLabel.textColor = OHColor(255, 119, 0, 1.0);
            }
            bindStatusLabel.textAlignment = NSTextAlignmentRight;
            bindStatusLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:bindStatusLabel];
            
            //分隔线
            [self initLineViewWithFrame:CGRectMake(0, 52*kAdaptationCoefficient, OHScreenW, 1)];
        }
        else if (indexPath.row == 3) {
            titleLabel.text = @"微博";
            
            UILabel *bindStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(OHScreenW-(12+16.5+200)*kAdaptationCoefficient, 0, 200*kAdaptationCoefficient, 52*kAdaptationCoefficient)];
            if ([OHCommon isEmptyOrNull:userInfoModel.weibo]) {
                
                bindStatusLabel.text = @"未绑定";
                bindStatusLabel.textColor = OHColor(153, 153, 153, 1.0);
            }
            else {
                self.userInteractionEnabled = NO;
                bindStatusLabel.text = @"已绑定";
                bindStatusLabel.textColor = OHColor(255, 119, 0, 1.0);
            }
            bindStatusLabel.textAlignment = NSTextAlignmentRight;
            bindStatusLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
            [self.contentView addSubview:bindStatusLabel];
        }
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
