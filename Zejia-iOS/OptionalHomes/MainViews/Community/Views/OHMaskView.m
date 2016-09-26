//
//  OHMaskView.m
//  OptionalHome
//
//  Created by Dr_liu on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//


#define KWITH   90    // 宽度
#define KHEIGHT 34    // 高度
#define KCOLCOUNNT 3  // 列数

#import "OHMaskView.h"
#import "OHFont.h"
#import "OHCommon.h"
#import "OHCommunityTagModel.h"
#import "OHCommunitySubTagModel.h"

@interface OHMaskView ()<UIScrollViewDelegate>
{
    NSMutableArray *_dateSource; //蒙层的model数组
}
@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UILabel *descripeLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView  *view;   // 覆盖在scrollview上的

@end

@implementation OHMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = OHColor(110, 110, 110, 0.6);
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    _dataArray = dataArray;
    [self setData];
    [self createSubViews];
}

-(void)setData{
    _dateSource = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary* tagDic in  _dataArray) {
        [_dateSource addObject:[self intoTheModel:tagDic]];
    }
}

// 写入模型
- (OHCommunityTagModel*)intoTheModel:(NSDictionary *)dic {
    OHCommunityTagModel *model = [OHCommunityTagModel mj_objectWithKeyValues:dic context:nil];
    NSArray *dicArray = dic[@"children"];
    model.children  = [OHCommunitySubTagModel mj_objectArrayWithKeyValuesArray:dicArray];
    return model ;
}

//model转字典
-(NSDictionary *)returnDic:(OHCommunityTagModel *)model{
    NSDictionary *modelDict = model.mj_keyValues;
    return modelDict;
}
//创建view
- (void)createSubViews {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, OHScreenH/2 - 50, OHScreenW, 65)];
    self.bgView.backgroundColor = OHColor(235, 235, 235, 1);
    [self addSubview:self.bgView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake((OHScreenW-105)/2, 20, 105, 20)];
    self.label.text = @"偏好特色选择";
    self.label.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    self.label.backgroundColor = OHColor(235, 235, 235, 1);
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.label];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(((OHScreenW-105)/2 - 30), 20, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"choose_title_icon"];
    [self.bgView addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 20, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"choose_title_icon"];
    [self.bgView addSubview:imageView2];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(OHScreenW - 45, 0, 45, 45);
    [cancleButton setImage:[UIImage imageNamed:@"choose_close_btn"] forState:UIControlStateNormal];
    [self.bgView addSubview:cancleButton];
    [cancleButton addTarget:self action:@selector(cancleViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置scrollview，滚动
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.frame), OHScreenW, OHScreenH/2 - 65)];
    self.scrollView.backgroundColor = OHColor(235, 235, 235, 1);
    [self addSubview:self.scrollView];
   
    // 此view添加到scrollview上，其它内容添加到view上
    for (int i = 0; i < _dateSource.count; i ++) {
        
        OHCommunityTagModel *tagModel = _dateSource[i];
        
        NSMutableArray* subTagArray = tagModel.children;
        int x=0;
        if (i==0) {
            x = 12 + i * (OHScreenW);
        }
        else{
           x = 12 + i * (OHScreenW)-24;
        }
        _view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, OHScreenW - 36, OHScreenH/2 - 10 - 65)];
        _view.backgroundColor = OHColor(255, 255, 255, 1);
        _view.layer.cornerRadius = 4;
        _view.tag = (i+1)*100;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_view.frame.size.width - 80)/2, 0, 80, 40)];
        self.titleLabel.text = tagModel.tagName;
        self.titleLabel.font = [OHFont systemFontOfSize:16.0*kAdaptationCoefficient];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = OHColor(51, 51, 51, 1);
        [_view addSubview:self.titleLabel];
        
        self.descripeLabel = [[UILabel alloc] init];
        
        self.descripeLabel.text = tagModel.desc;
        self.descripeLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        self.descripeLabel.numberOfLines = 0;
        self.descripeLabel.textColor = OHColor(153,153, 153, 1);
        CGFloat with = _view.frame.size.width - 100;
        CGFloat height = [OHCommon getLabelHeightWith:self.descripeLabel.text andWidth:with andFont:17];
        self.descripeLabel.frame = CGRectMake(50, CGRectGetMaxY(self.titleLabel.frame), with, height);
        [_view addSubview:self.descripeLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.descripeLabel.frame)+12, _view.frame.size.width - 24, 1)];
        self.lineView.backgroundColor = OHColor(238, 238, 238, 1);
        [_view addSubview:self.lineView];
        
        CGFloat marginX = (_view.frame.size.width - KCOLCOUNNT * KWITH) / (KCOLCOUNNT + 1);
        CGGlyph marginY = 15;
        for (int i = 0; i < subTagArray.count; i ++) {
            
           OHCommunitySubTagModel* subModel = subTagArray[i];
            
            int row = i / KCOLCOUNNT;  // 行
            int col = i % KCOLCOUNNT;  // 列
            CGFloat X = marginX+10 + col * (marginX - 10 + KWITH);
            CGFloat Y = (CGRectGetMaxY(self.lineView.frame) + row * (marginY + KHEIGHT) + 20);
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(X, Y, KWITH*kAdaptationCoefficient, KHEIGHT*kAdaptationCoefficient);
            [button setTitle:subModel.tagName forState:UIControlStateNormal];
            button.titleLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
            [button setTitleColor:OHColor(102, 102, 102, 1) forState:UIControlStateNormal];
            [button setTitleColor:OHColor(255, 255, 255, 1) forState:UIControlStateSelected];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 17*kAdaptationCoefficient;
            button.layer.borderWidth = 1;
            button.layer.borderColor = OHColor(102, 102, 102, 0.3).CGColor;
            button.selected = subModel.isCheck.intValue ;
            if (button.selected) {
                button.backgroundColor = OHColor(255, 119, 0, 1);
                button.layer.borderColor = OHColor(255, 119, 0, 1).CGColor;
                
#warning 保存按钮变色
//                [self.saveButton setBackgroundColor:OHColor(251, 229, 88, 1)];
            }else{
                button.backgroundColor = OHColor(255, 255, 255, 1);
            }
            button.tag = i + 100;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_view addSubview:button];
        }
        
        // 此view是覆盖在scrollview上的
        [self.scrollView addSubview:_view];
    }
    
    self.scrollView.delegate = self;
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTintColor:OHColor(105, 49, 25, 1)];
        [self.saveButton setBackgroundColor:OHColor(252, 228, 72, 1)];
    self.saveButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    self.saveButton.frame = CGRectMake(0, OHScreenH - 50, OHScreenW, 50);
    [self addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置scrollview的可移动范围
    self.scrollView.contentSize = CGSizeMake(OHScreenW * 9, 0);
    self.scrollView.pagingEnabled = YES;   // 设置分页
    // 设置偏移量
    self.scrollView.contentOffset = CGPointMake(self.pageIndex * (OHScreenW), 0);
    UIView *view1 = [self.scrollView viewWithTag:(self.pageIndex+1)*100];
    view1.frame = CGRectMake(12 + self.pageIndex * (OHScreenW), 0, OHScreenW - 36, OHScreenH/2 - 10 - 65);
    UIView *view2 = [self.scrollView viewWithTag:(self.pageIndex+2)*100];
    view2.frame = CGRectMake(12 + (self.pageIndex+1) * (OHScreenW)-24, 0, OHScreenW - 36, OHScreenH/2 - 10 - 65);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageIndex = scrollView.contentOffset.x/ OHScreenW;
    self.pageIndex = pageIndex ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageIndex = ceilf(scrollView.contentOffset.x/ OHScreenW);
    UIView *view1 = [scrollView viewWithTag:(pageIndex+1)*100];
    view1.frame = CGRectMake(12 + pageIndex * (OHScreenW), 0, OHScreenW - 36, OHScreenH/2 - 10 - 65);
    UIView *view2 = [scrollView viewWithTag:(pageIndex+2)*100];
    view2.frame = CGRectMake(12 + (pageIndex+1) * (OHScreenW)-24, 0, OHScreenW - 36, OHScreenH/2 - 10 - 65);
}
#pragma mark - 保存按钮事件
- (void)saveButtonAction:(UIButton *)button {
    NSMutableArray *dicArr = [NSMutableArray arrayWithCapacity:0];
    for (OHCommunityTagModel *model in _dateSource) {
       NSDictionary *dic =  [self returnDic:model];
        [dicArr addObject:dic];
    }
    if ([self.delegate respondsToSelector:@selector(backData:)]) {
        [self.delegate backData:dicArr];
    }
    [self removeFromSuperview];
}

#pragma mark - 自标签按钮的点击事件
- (void)buttonAction:(UIButton *)button {
    NSInteger index = button.tag-100;
    button.selected = !button.selected;
    OHCommunityTagModel *tagModel = _dateSource[self.pageIndex];
   
    OHCommunitySubTagModel* subTagModel = tagModel.children[index];
    subTagModel.isCheck = [NSNumber numberWithBool:button.selected];
    
    if (button.selected == YES)
    {
        button.backgroundColor = OHColor(255, 119, 0, 1);
        button.layer.borderColor = OHColor(255, 119, 0, 1).CGColor;
        
#warning 保存按钮
    }
    else
    {
        button.backgroundColor = OHColor(255, 255, 255, 1);
        button.layer.borderColor = OHColor(102, 102, 102, 0.3).CGColor;
    }
    NSLog(@"=-=😄-=");
}

#pragma mark - 移除蒙板view
- (void)cancleViewAction:(UIButton *)btn {
    [self removeFromSuperview];
}

@end
