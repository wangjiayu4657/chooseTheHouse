//
//  OHRegisterStepTwoViewController.m
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHRegisterStepTwoViewController.h"
#import "OHCommunityViewController.h"
#import "OHHomeViewController.h"

#import "OHLoginModel.h"

@interface OHRegisterStepTwoViewController ()<UITextFieldDelegate>
{
    UITextField *_passWordTextField;        //密码输入框
    
    UIView *_bgView1;
    UIButton *_registerButton;              //确认注册按钮
}
@end

@implementation OHRegisterStepTwoViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_passWordTextField endEditing:YES];
}

- (void)viewDidLoad {
    
    self.titleStr = @"手机注册";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    self.rightButtonStatus = rightButtonWithTitle;
    self.rightCustomButtonTitle = @"登录";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:)   name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //创建视图
    [self initRegisterStepTwoView];
}

//创建视图
- (void)initRegisterStepTwoView {
    
    //创建公共视图1
    [self initCustomView1WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) ImageName:@"login_password_icon" Tag:1];
    
    //确认注册按钮
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_bgView1.frame)+36*kAdaptationCoefficient, OHScreenW-24*2*kAdaptationCoefficient, 50*kAdaptationCoefficient)];
    [_registerButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    [_registerButton setTitle:@"确认注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    _registerButton.layer.cornerRadius = 4;
    _registerButton.enabled = NO;
    [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    //tips
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, OHScreenH-60*kAdaptationCoefficient, OHScreenW, 60*kAdaptationCoefficient)];
    tipsLabel.backgroundColor = OHColor(249, 249, 249, 1.0);
    tipsLabel.text = @"温馨提示：确认注册代表您同意用户协议";
    tipsLabel.textColor = OHColor(153, 153, 153, 1.0);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    [self.view addSubview:tipsLabel];
}

//创建公共视图1
- (void)initCustomView1WithLogoImageViewFrame:(CGRect)frame ImageName:(NSString *)imageName Tag:(NSInteger)tag {
    
    //底层视图
    _bgView1 = [[UIView alloc] init];
    _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(frame), OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView1];
    
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_bgView1.frame)-24*kAdaptationCoefficient)/2.0, 24*kAdaptationCoefficient, 24*kAdaptationCoefficient)];
    iconImageView.image = [UIImage imageNamed:imageName];
    [_bgView1 addSubview:iconImageView];
    
    //账户密码
    _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView1.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView1.frame)-(CGRectGetWidth(iconImageView.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _passWordTextField.tag = tag;
    _passWordTextField.delegate = self;
    _passWordTextField.placeholder = @"请设置账户密码";
    _passWordTextField.keyboardType = UIKeyboardTypeDefault;
    _passWordTextField.borderStyle = UITextBorderStyleNone;
    _passWordTextField.backgroundColor = [UIColor whiteColor];
    [_passWordTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _passWordTextField.textAlignment = NSTextAlignmentLeft;
    _passWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordTextField.secureTextEntry = YES;
    [_bgView1 addSubview:_passWordTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView1.frame)-1, CGRectGetWidth(_bgView1.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView1 addSubview:lineView];
}


//点击确认注册按钮
- (void)registerButtonClick {
    
    NSString *passWordText = _passWordTextField.text;
    NSLog(@"passWordText=%@",passWordText);
    
    //用户注册请求
    [self UserRegisterRequestWithMobile:self.mobileNum PassWord:passWordText];
}

//用户注册请求
- (void)UserRegisterRequestWithMobile:(NSString *)mobile PassWord:(NSString *)password {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"userReg" andDic:@{@"mobile":mobile,@"pwd":password} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            //注册成功后，直接登录
            [self UserLoginRequestWithMobile:mobile PassWord:password];
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//用户登录请求
- (void)UserLoginRequestWithMobile:(NSString *)mobile PassWord:(NSString *)password {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"userLogin" andDic:@{@"mobile":mobile,@"pwd":password} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            OHLoginModel *loginModel = [OHLoginModel mj_objectWithKeyValues:[dic objectForKey:@"response"]];
            
            //保存sessionId、nickName、avaterUrl、inHome到本地
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.sessionId forKey:@"SessionId"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.nickname forKey:@"NickName"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.photoUrl forKey:@"AvaterUrl"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.inHome forKey:@"InHome"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"kSessionIdkSessionId_register_login=%@",kSessionId);
            
            //登录成功后，数据统计
            [XXReporter setUserID:kSessionId];
            
            if ([kInHome isEqualToString:@"1"]) {       //去首页
                
                //登录成功，跳转到首页
                if ([[[self.navigationController viewControllers] objectAtIndex:0] isKindOfClass:[OHHomeViewController class]]) {
                    OHHomeViewController *homeVC = [[self.navigationController viewControllers] objectAtIndex:0] ;
                    [homeVC resetSomeThing];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else{
                    OHHomeViewController *homeVC = [[OHHomeViewController alloc] init];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
            }
            else {      //去标签页
                
                //登录成功，跳转到社区特色页
                OHCommunityViewController *communityVC = [[OHCommunityViewController alloc] init];
                [self.navigationController pushViewController:communityVC animated:YES];
            }
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            [self performSelector:@selector(backToLoginView) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//返回到登录页面
- (void)backToLoginView {
    
    [self.navigationController popToViewController:(UIViewController *)_loginVC animated:YES];
}

//子类重写点击右侧单个按钮的事件
//点击“登录”按钮
- (void)rightCustomButtonClick:(UIButton *)sender {
    
    [self.navigationController popToViewController:(UIViewController *)_loginVC animated:YES];
}

#pragma mark - 通知方法
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat moveHeight = keyboardHeight - (OHScreenH-CGRectGetMaxY(_bgView1.frame));
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (moveHeight >= 0) {
//            _logoImageView.frame = CGRectMake((OHScreenW-140*kAdaptationCoefficient)/2.0, kNaviHeight+44*kAdaptationCoefficient-moveHeight, 140*kAdaptationCoefficient, 140*kAdaptationCoefficient);
//            _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+74*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
        }
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
//        _logoImageView.frame = CGRectMake((OHScreenW-140*kAdaptationCoefficient)/2.0, kNaviHeight+44*kAdaptationCoefficient, 140*kAdaptationCoefficient, 140*kAdaptationCoefficient);
//        _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+74*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)obj {
    
    if (![OHCommon isEmptyOrNull:_passWordTextField.text]) {
        
        _registerButton.enabled = YES;
        [_registerButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
    }
    else {
        
        _registerButton.enabled = NO;
        [_registerButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    }
}

#pragma mark - UITextFieldDelegate 代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕，键盘消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_passWordTextField endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
