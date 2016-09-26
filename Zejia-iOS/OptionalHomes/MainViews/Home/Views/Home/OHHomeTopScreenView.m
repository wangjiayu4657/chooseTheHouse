//
//  OHHomeTopScreenView.m
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHomeTopScreenView.h"

@implementation OHHomeTopScreenView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *titArr = @[@"区域",@"价格",@"智能排序"];
        //按钮
        for (int i = 0; i < 3; i++) {
            OHTextAndImageButton *btn = [OHTextAndImageButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((OHScreenW/3)*i, 0,OHScreenW/3,OHScreenW/3);
            btn.tag = (i + 1)*10;
            [btn setButtomImage:@"home_arrow_down" title:titArr[i]];
            [btn addTarget:self action:@selector(ButtonClick:)forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        //分隔线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-1.0, OHScreenW, 1.0)];
        lineLabel.backgroundColor = OHColor(238, 238, 238, 1.0);
        [self addSubview:lineLabel];
    }
    return self;
}
-(void)ButtonClick:(UIButton *)sender{
    OHTextAndImageButton *btn = (OHTextAndImageButton *)sender;
    btn.isSelected = !btn.isSelected;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat angle;
        if (btn.isSelected) {
            angle = M_PI;;
        }
        else{
            angle = -M_PI*2;
        }
        btn.buttomImage.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(everyScreenBtnClick:btn:)]) {
        [self.delegate everyScreenBtnClick:sender.tag btn:btn];
    }
}
@end
