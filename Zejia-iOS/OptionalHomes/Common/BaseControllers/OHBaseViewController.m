//
//  OHBaseViewController.m
//  OptionalHome
//
//  Created by haili on 16/7/18.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"

@interface OHBaseViewController ()

@end

@implementation OHBaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.canDragBack = YES;
        self.isShowNaviView = YES;
//        self.leftCanPanEnabled = NO;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self setLeftViewPanStatus];
    if (self.canDragBack==YES) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
       if (self.isShowNaviView==YES) {
        [self initCustomNaviView];
    }
}

//自定义导航栏
- (void)initCustomNaviView{
    //导航
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OHScreenW, kNaviHeight)];
    _naviView.backgroundColor = kOHThemeColor;
    [self.view addSubview:_naviView];
    
    //左侧自定义按钮
    if (self.leftButtonStatus == leftButtonWithTitle) {
        
        //返回按钮
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(12, kStatusHeight, [OHCommon getLabelWidthWith:_leftCustomButtonTitle and:15.0], kNaviBarHeight)];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton setTitle:_leftCustomButtonTitle forState:UIControlStateNormal];
        [_backButton setTitleColor:OHColor(40, 35, 35, 1.0) forState:UIControlStateNormal];
        _backButton.titleLabel.font = [OHFont systemFontOfSize:15.0];
        [_backButton addTarget:self action:@selector(baseBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:_backButton];
    }
    else if (self.leftButtonStatus == leftButtonWithImage) {
        
        //返回按钮
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(0, kStatusHeight, kNaviBarHeight, kNaviBarHeight)];
        [_backButton setBackgroundImage:[UIImage imageNamed:_leftCustomButtonImage] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(baseBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:_backButton];
    }
    //右侧自定义按钮
    _rightCustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.rightButtonStatus == rightButtonWithTitle) {
        
        [_rightCustomButton setFrame:CGRectMake(OHScreenW-[OHCommon getLabelWidthWith:self.rightCustomButtonTitle and:15.0]-10, kStatusHeight, [OHCommon getLabelWidthWith:self.rightCustomButtonTitle and:15.0], kNaviBarHeight)];
        [_rightCustomButton setTitle:self.rightCustomButtonTitle forState:UIControlStateNormal];
        [_rightCustomButton setTitleColor:OHColor(40, 35, 35, 1.0) forState:UIControlStateNormal];
        _rightCustomButton.titleLabel.font = [OHFont systemFontOfSize:15.0];
        [_rightCustomButton setBackgroundColor:[UIColor clearColor]];
        [_rightCustomButton addTarget:self action:@selector(rightCustomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:_rightCustomButton];
    }
    else if (self.rightButtonStatus == rightButtonWithImage) {
        
        [_rightCustomButton setFrame:CGRectMake(OHScreenW-kNaviBarHeight, kStatusHeight, kNaviBarHeight,kNaviBarHeight)];
        [_rightCustomButton setBackgroundImage:[UIImage imageNamed:self.rightCustomButtonImage] forState:UIControlStateNormal];
        [_rightCustomButton addTarget:self action:@selector(rightCustomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:_rightCustomButton];
    }
    
    //标题
    CGFloat titleLabelX = CGRectGetWidth(_backButton.frame)>CGRectGetWidth(_rightCustomButton.frame)?CGRectGetWidth(_backButton.frame):CGRectGetWidth(_rightCustomButton.frame);//标题的横坐标
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, kStatusHeight, OHScreenW-2*titleLabelX, kNaviBarHeight)];
    _titleLabel.text = self.titleStr;
    _titleLabel.textColor = OHColor(40, 35, 35, 1.0);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [OHFont systemFontOfSize:18.0];
   [_naviView addSubview:_titleLabel];
    
}

////设置是否可以手势拖出抽屉
//-(void)setLeftViewPanStatus{
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (self.leftCanPanEnabled == NO) {
//        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
//    }
//    else{
//        [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
//        
//    }
//}
//子类重写点击左侧返回按钮的事件
- (void)baseBackButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//子类重写点击右侧单个按钮的事件
- (void)rightCustomButtonClick:(UIButton *)sender {
    
    NSLog(@"rightCustomButtonClick");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
