//
//  OHChooseLoginWayView.m
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHChooseLoginWayView.h"
#import "WXApi.h"

@implementation OHChooseLoginWayView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if (OHScreenH==480) {
            imageView.image = [UIImage imageNamed:@"guide_page4"];
        }else{
            imageView.image = [UIImage imageNamed:@"guide_page4+"];
        }
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        //图片数组
        NSArray *nomalImageArr = @[@"guide_page3_wechat_btn",@"guide_page3_qq_btn",@"guide_page3_blog_btn",@"guide_page3_phone_btn"];
        NSArray *pressImageArr = @[@"guide_page3_wechat_btn_press",@"guide_page3_qq_btn_press",@"guide_page3_blog_btn_press",@"guide_page3_phone_btn_press"];
        //隐私说明按钮
        UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        explainBtn.frame = CGRectMake((frame.size.width-(240*kAdaptationCoefficient))/2, frame.size.height-50, 240*kAdaptationCoefficient, 25*kAdaptationCoefficient);
        explainBtn.tag = 50;
        [explainBtn setTitle:@"用户隐私说明及其他信息，点击查看>" forState:UIControlStateNormal];
        explainBtn.titleLabel.font = [OHFont systemFontOfSize:12.0*kAdaptationCoefficient];
        explainBtn.layer.cornerRadius = 25*kAdaptationCoefficient/2;
        explainBtn.backgroundColor = OHColor(0, 0, 0, 0.1);
        [explainBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:explainBtn];
        
        //登录方式的按钮
        NSInteger btnY = CGRectGetMinY(explainBtn.frame)-64-60*kAdaptationCoefficient;
        int number;        //按钮数量
         if ([WXApi isWXAppInstalled] == NO) {   //未安装微信
             number =3;
         }
         else{
             number = 4;
         }
        for (int i = 0; i < number; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (number==3) {
                btn.tag = (i + 2)*10;
                [btn setImage:[UIImage imageNamed:nomalImageArr[i+1]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:pressImageArr[i+1]] forState:UIControlStateHighlighted];
            }
            else if (number==4){
                btn.tag = (i + 1)*10;
                [btn setImage:[UIImage imageNamed:nomalImageArr[i]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:pressImageArr[i]] forState:UIControlStateHighlighted];
            }
           
            [btn addTarget:self action:@selector(ButtonClick:)forControlEvents:UIControlEventTouchUpInside];
            int xInterval;
            xInterval = (frame.size.width-60*kAdaptationCoefficient*number)/(number+1);
            int x;
            x = xInterval+(60*kAdaptationCoefficient+xInterval)*i;
            btn.frame = CGRectMake(x, btnY, 60*kAdaptationCoefficient,60*kAdaptationCoefficient);
            [imageView addSubview:btn];
        }
        UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-105*kAdaptationCoefficient)/2, btnY-34-20*kAdaptationCoefficient, 105*kAdaptationCoefficient, 20*kAdaptationCoefficient)];
        explainLabel.text = @"选择登录方式";
        explainLabel.textAlignment = NSTextAlignmentCenter;
        explainLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        explainLabel.textColor = [UIColor whiteColor];
        [imageView addSubview:explainLabel];
        
        UILabel *lineLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(explainLabel.frame)-80, CGRectGetMidY(explainLabel.frame), 70, 1)];
        lineLabelLeft.backgroundColor = [UIColor whiteColor];
        [imageView addSubview:lineLabelLeft];
        
        UILabel *lineLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(explainLabel.frame)+10, CGRectGetMidY(explainLabel.frame), 70, 1)];
        lineLabelRight.backgroundColor = [UIColor whiteColor];
        [imageView addSubview:lineLabelRight];
        
    }
    return self;
}

-(void)ButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(everyBtnClick:)]) {
        [self.delegate everyBtnClick:sender.tag];
    }
}

@end
