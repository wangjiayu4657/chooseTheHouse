//
//  OHLoginViewController.m
//  OptionalHome
//
//  Created by lujun on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLoginViewController.h"
#import "CustomPhoneNumberFormat.h"
#import "OHRegisterViewController.h"
#import "OHForgetPassWordViewController.h"
#import "OHCommunityViewController.h"
#import "OHHomeViewController.h"
#import "OHLoginModel.h"

@interface OHLoginViewController ()<UITextFieldDelegate>
{
    CustomPhoneNumberFormat *_phoneNumberTextFiled;         //手机号码输入框
    UITextField *_passWordTextField;                        //密码输入框
    
    UIView *_bgView1;
    UIView *_bgView2;
    UIButton *_loginButton;
}
@end

@implementation OHLoginViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_phoneNumberTextFiled endEditing:YES];
    [_passWordTextField endEditing:YES];
}

- (void)viewDidLoad {
    
    self.titleStr = @"手机登录";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    self.rightButtonStatus = rightButtonWithTitle;
    self.rightCustomButtonTitle = @"注册";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:)   name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    //创建视图
    [self initLoginView];
}

//创建视图
- (void)initLoginView {
    
    //创建公共视图1
    [self initCustomView1WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) ImageName:@"login_phone_icon" Tag:1];
    
    //创建公共视图2
    [self initCustomView2WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) ImageName:@"login_password_icon" Tag:2];
    
    //确认登录按钮
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_bgView2.frame)+36*kAdaptationCoefficient, OHScreenW-24*2*kAdaptationCoefficient, 50*kAdaptationCoefficient)];
    [_loginButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    [_loginButton setTitle:@"确认登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    _loginButton.layer.cornerRadius = 4;
    _loginButton.enabled = NO;
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    //忘记密码按钮
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setFrame:CGRectMake((OHScreenW-120*kAdaptationCoefficient)/2.0, CGRectGetMaxY(_loginButton.frame)+14*kAdaptationCoefficient, 120*kAdaptationCoefficient, 40*kAdaptationCoefficient)];
    [forgetButton setBackgroundColor:[UIColor whiteColor]];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:OHColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    [forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
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
    
    _phoneNumberTextFiled = [[CustomPhoneNumberFormat alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView1.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView1.frame)-(CGRectGetWidth(iconImageView.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _phoneNumberTextFiled.tag = tag;
    _phoneNumberTextFiled.placeholder = @"请输入手机号";
    _phoneNumberTextFiled.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberTextFiled.borderStyle = UITextBorderStyleNone;
    _phoneNumberTextFiled.textColor = OHColor(51, 51, 51, 1.0);
    _phoneNumberTextFiled.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [_bgView1 addSubview:_phoneNumberTextFiled];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView1.frame)-1, CGRectGetWidth(_bgView1.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView1 addSubview:lineView];
    
    [_phoneNumberTextFiled setBlock:^(NSString*textStr){
    }];
}

//创建公共视图2
- (void)initCustomView2WithLogoImageViewFrame:(CGRect)frame ImageName:(NSString *)imageName Tag:(NSInteger)tag {
    
    //底层视图
    _bgView2 = [[UIView alloc] init];
    _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(frame)+(40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView2];
    
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_bgView2.frame)-24*kAdaptationCoefficient)/2.0, 24*kAdaptationCoefficient, 24*kAdaptationCoefficient)];
    iconImageView.image = [UIImage imageNamed:imageName];
    [_bgView2 addSubview:iconImageView];
        
    _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView2.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView2.frame)-(CGRectGetWidth(iconImageView.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _passWordTextField.tag = tag;
    _passWordTextField.delegate = self;
    _passWordTextField.placeholder = @"请输入密码";
    _passWordTextField.keyboardType = UIKeyboardTypeDefault;
    _passWordTextField.borderStyle = UITextBorderStyleNone;
    _passWordTextField.backgroundColor = [UIColor whiteColor];
    [_passWordTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _passWordTextField.textAlignment = NSTextAlignmentLeft;
    _passWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordTextField.secureTextEntry = YES;
    [_bgView2 addSubview:_passWordTextField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView2.frame)-1, CGRectGetWidth(_bgView2.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView2 addSubview:lineView];
}

//点击确认登录按钮
- (void)loginButtonClick {
    
    NSLog(@"确认登录");
    NSString *phoneNumberText = [OHCommon removeWhiteSpace:_phoneNumberTextFiled.text];
    NSString *passWordText = _passWordTextField.text;
    
    NSLog(@"phoneNumberText=%@，passWordText=%@",phoneNumberText,passWordText);
    
    //用户登录请求
    [self UserLoginRequestWithMobile:phoneNumberText PassWord:passWordText];
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
            
            NSLog(@"kSessionIdkSessionId_login=%@",kSessionId);
            
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
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//点击忘记密码按钮
- (void)forgetButtonClick {
    
    NSLog(@"忘记密码");
    OHForgetPassWordViewController *forgetPassWordVC = [[OHForgetPassWordViewController alloc] init];
    forgetPassWordVC.loginVC = self;
    [self.navigationController pushViewController:forgetPassWordVC animated:YES];
}

//子类重写点击右侧单个按钮的事件
//点击“注册”按钮
- (void)rightCustomButtonClick:(UIButton *)sender {
    
    OHRegisterViewController *registerVC = [[OHRegisterViewController alloc] init];
    registerVC.loginVC = self;
    [self.navigationController pushViewController:registerVC animated:YES];
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
    CGFloat moveHeight = 0;
    if ([_phoneNumberTextFiled isFirstResponder]) {
        moveHeight = keyboardHeight - (OHScreenH-CGRectGetMaxY(_bgView1.frame));
    }
    else if ([_passWordTextField isFirstResponder]) {
        moveHeight = keyboardHeight - (OHScreenH-CGRectGetMaxY(_bgView2.frame));
    }
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (moveHeight >= 0) {
//            _logoImageView.frame = CGRectMake((OHScreenW-140*kAdaptationCoefficient)/2.0, kNaviHeight+44*kAdaptationCoefficient-moveHeight, 140*kAdaptationCoefficient, 140*kAdaptationCoefficient);
//            _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+42*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
//            _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+(42+40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
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
//        _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+42*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
//        _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_logoImageView.frame)+(42+40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)obj {
    
    if ([OHCommon validateMobile:[OHCommon removeWhiteSpace:_phoneNumberTextFiled.text]] && ![OHCommon isEmptyOrNull:_passWordTextField.text]) {
        
        _loginButton.enabled = YES;
        [_loginButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
    }
    else {
        
        _loginButton.enabled = NO;
        [_loginButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    }
}

#pragma mark - UITextFieldDelegate 代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕，键盘消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_phoneNumberTextFiled endEditing:YES];
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
