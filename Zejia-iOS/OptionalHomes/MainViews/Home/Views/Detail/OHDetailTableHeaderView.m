//
//  OHDetailTableHeaderView.m
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHDetailTableHeaderView.h"
#import "OHDetailModel.h"
#import "OHHomeMapDetailController.h"
#import "OHWebViewController.h"


//static CGFloat const margin = 12;

@interface OHDetailTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
//全景图片
@property (weak, nonatomic) IBOutlet UIImageView *panoramaImageView;
//社区名称
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
//建筑年代
@property (weak, nonatomic) IBOutlet UILabel *buildAgeLabel;
//标签:建筑年代
@property (weak, nonatomic) IBOutlet UILabel *buildAgeTitleLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//均价
@property (weak, nonatomic) IBOutlet UILabel *avgPriceLabel;
//行政区
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
//片区
@property (weak, nonatomic) IBOutlet UILabel *plateLabel;
//全景图片展示h5的地址
@property (weak, nonatomic) IBOutlet UIButton *pano360UrlButton;
//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@end

@implementation OHDetailTableHeaderView

+ (instancetype)showTableHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageH = CGRectGetHeight(self.panoramaImageView.frame);
    CGFloat bottomViewH = CGRectGetHeight(self.bottomView.frame);
    self.headerViewHeight = imageH + bottomViewH + 17 * kAdaptationCoefficient;
//    NSLog(@"xxxheaderViewHeight == %.1f",self.headerViewHeight);
    Singleton *single = [Singleton shareSingleton];
    if (IS_iPhone5) {
        single.headerViewHeight = 403;
    }else if (IS_iPhone_6) {
        single.headerViewHeight = 447;
    }else if (IS_iPhone_6p) {
        single.headerViewHeight = 478;
    }
}


- (void)setModel:(OHDetailModel *)model {
    
    _model = model;
    if (![model.pano360Url isEqualToString:@""]) {
        self.pano360UrlButton.hidden = NO;
        [self.pano360UrlButton addTarget:self action:@selector(pano360UrlButtonClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.pano360UrlButton.hidden = YES;
    }
    
    if (model.isFollow == 1) {
        [self.focusButton setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
        self.focusButton.selected = YES;
    } else {
        [self.focusButton setImage:[UIImage imageNamed:@"unlike_icon"] forState:UIControlStateNormal];
        self.focusButton.selected = NO;
    }
    self.buildAgeTitleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    [self.panoramaImageView sd_setImageWithURL:[NSURL URLWithString:model.panoUrl] placeholderImage:[UIImage imageNamed:@"housing_pic"]];
    self.communityNameLabel.text = model.communityName;
    self.communityNameLabel.font = [OHFont systemFontOfSize:20 * kAdaptationCoefficient];
    self.buildAgeLabel.text = model.buildAge;
    self.buildAgeLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.addressLabel.text = model.address;
    self.addressLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.avgPriceLabel.text = [self conversionString:model.avgPrice];
    self.avgPriceLabel.font = [OHFont systemFontOfSize:18 * kAdaptationCoefficient];
    self.regionLabel.text = model.region;
    self.regionLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
    self.plateLabel.text = model.plate;
    self.plateLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
}

- (void) pano360UrlButtonClick{
    OHWebViewController *webVC = [[OHWebViewController alloc] initWithURL:[NSURL URLWithString:self.model.pano360Url] andTitle:@"全景图"];
    if ([self.window.rootViewController.childViewControllers[1] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController.childViewControllers[1];
        [controller pushViewController:webVC animated:YES];
    }
}

- (NSString *) conversionString:(NSNumber *) object {
    NSString *string = [NSString stringWithFormat:@"￥%@/㎡",object];
    return string;
}

- (IBAction)addressButton:(UIButton *)sender {    
    OHHomeMapDetailController *detailController = [[OHHomeMapDetailController alloc] init];
    detailController.communityId = [NSString stringWithFormat:@"%@",self.communityId];
    detailController.latitude = self.model.latitude;
    detailController.longitude = self.model.longitude;
    detailController.communityName = self.model.communityName;
    
    if ([self.window.rootViewController.childViewControllers[1] isKindOfClass:[UINavigationController class]]) {
         UINavigationController *controller = (UINavigationController *)self.window.rootViewController.childViewControllers[1];
        [controller pushViewController:detailController animated:YES];
    }
}

- (IBAction)focusOnButton:(UIButton *)sender {
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
        sender.selected = YES;
        [self focusOn];
    }else {
        [sender setImage:[UIImage imageNamed:@"unlike_icon"] forState:UIControlStateNormal];
        sender.selected = NO;
        [self cancleFocusOn];
    }
}

//添加关注
- (void) focusOn {
      __weak typeof (self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        [AFServer requestDataWithUrl:@"addFollow" andDic:@{@"sessionId":kSessionId,@"communityId":self.communityId} completion:^(NSDictionary *dic) {
              [MBProgressHUD hideHUDForView:self.superview animated:YES];
              [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.superview];
             !weakSelf.completed ? :weakSelf.completed(@"add");
        } failure:^(NSError *error) {
              [MBProgressHUD hideHUDForView:self.superview animated:YES];
              [OHCommon showWeakTips:[NSString stringWithFormat:@"%@",error] View:self.superview];
        }];
}

//取消关注
- (void) cancleFocusOn {
     __weak typeof (self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    [AFServer requestDataWithUrl:@"deleteFollow" andDic:@{@"sessionId":kSessionId,@"communityId":self.communityId} completion:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.superview animated:YES];
        [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.superview];
        !weakSelf.completed ? :weakSelf.completed(@"cancle");
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.superview animated:YES];
        [OHCommon showWeakTips:[NSString stringWithFormat:@"%@",error] View:self.superview];
    }];
}



////////////////////////////////////////////////////////////////////////////////////////

/*
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void) setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewHeight = 3 * OHScreenW / 4.0;
    imageView.size = CGSizeMake(OHScreenW, imageViewHeight);
    imageView.x = 0;
    imageView.y = 0;
    imageView.image = [UIImage imageNamed:@"house_icon.png"];
    [self addSubview:imageView];
    //标题
    CGFloat communityNameLabelY = CGRectGetMaxY(imageView.frame);
    UILabel *communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin , communityNameLabelY + 12, OHScreenW - 270 * kAdaptationCoefficient, 24 * kAdaptationCoefficient)];
    communityNameLabel.backgroundColor = [UIColor redColor];
    [self addSubview:communityNameLabel];
    
    //关注按钮
    CGFloat focusCenterY = communityNameLabel.centerY;
    UIButton *focus = [UIButton buttonWithType:UIButtonTypeCustom];
    [focus setImage:[UIImage imageNamed:@"unlike_icon.png"] forState:UIControlStateNormal];
    focus.size = focus.currentImage.size;
    focus.x = OHScreenW - focus.width - margin;
    focus.centerY = focusCenterY;
    [self addSubview:focus];
    
    //建筑年代
    UILabel *buildLabel = [[UILabel alloc] init];
    CGFloat buildLbaelY = CGRectGetMaxY(communityNameLabel.frame) + 12;
    buildLabel.text = @"建筑年代:";
    buildLabel.x = margin;
    buildLabel.y = buildLbaelY;
    [buildLabel sizeToFit];
    [self addSubview:buildLabel];
    
    UILabel *yearLabel = [[UILabel alloc] init];
    CGFloat  yearLabelY = buildLabel.centerY;
    CGFloat yearLabelX = CGRectGetMaxX(buildLabel.frame) + 5;
    yearLabel.x = yearLabelX;
    yearLabel.centerY = yearLabelY;
    yearLabel.text = @"2005";
    [yearLabel sizeToFit];
    [self addSubview:yearLabel];
    
    //行政区
    UILabel *regionLabel = [[UILabel alloc] init];
    CGFloat regionLabelY = CGRectGetMaxY(buildLabel.frame) + 8;
    regionLabel.x = margin;
    regionLabel.y = regionLabelY;
    regionLabel.text = @"杨浦区";
    [regionLabel sizeToFit];
    [self addSubview:regionLabel];
    
    //片区
    UILabel *plateLabel = [[UILabel alloc] init];
    CGFloat plateLabelX = CGRectGetMaxX(regionLabel.frame) + 5;
    CGFloat plateLabelCenterY = regionLabel.centerY;
    plateLabel.x = plateLabelX;
    plateLabel.centerY = plateLabelCenterY;
    plateLabel.text = @"五角场";
    [plateLabel sizeToFit];
    [self addSubview:plateLabel];
    
    //均价
    UILabel *avgPriceLabel = [[UILabel alloc] init];
    avgPriceLabel.text = @"$78000/m";
    CGSize size = [avgPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[OHFont systemFontOfSize:18 * kAdaptationCoefficient]}];
    avgPriceLabel.x = OHScreenW - size.width - margin;
    CGFloat avgPriceLabelCenterY = regionLabel.centerY;
    avgPriceLabel.centerY = avgPriceLabelCenterY;
    [avgPriceLabel sizeToFit];
    [self addSubview:avgPriceLabel];
    
    UILabel *avgPriceTitleLabel = [[UILabel alloc] init];
    CGFloat avgPriceTitleLabelX = CGRectGetMinX(avgPriceLabel.frame) + 5;
    avgPriceTitleLabel.text = @"均价";
    avgPriceTitleLabel.x = avgPriceTitleLabelX;
    avgPriceTitleLabel.centerY = avgPriceLabel.centerY;
    [avgPriceTitleLabel sizeToFit];
    [self addSubview:avgPriceTitleLabel];
    
    
}
*/
////////////////////////////////////////////////////////////////////////////////////////////////


@end
