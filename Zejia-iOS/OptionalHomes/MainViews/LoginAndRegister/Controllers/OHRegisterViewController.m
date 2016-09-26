//
//  OHRegisterViewController.m
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHRegisterViewController.h"
#import "CustomPhoneNumberFormat.h"
#import "MZTimerLabel.h"
#import "OHRegisterStepTwoViewController.h"

@interface OHRegisterViewController ()<UITextFieldDelegate, MZTimerLabelDelegate>
{
    CustomPhoneNumberFormat *_phoneNumberTextFiled;         //手机号码输入框
    UITextField *_codeTextField;                            //验证码输入框
    UIButton *_getCodeButton;                               //获取验证码按钮
    MZTimerLabel *_timeLabel;
    
    UIView *_bgView1;
    UIView *_bgView2;
    UIButton *_nextButton;              //下一步按钮
    
    BOOL _isCountFinished;              //是否倒计时完成(YES：倒计时完成。NO:倒计时未完成)
}
@end

@implementation OHRegisterViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_phoneNumberTextFiled endEditing:YES];
    [_codeTextField endEditing:YES];
}

- (void)viewDidLoad {
    
    self.titleStr = @"手机注册";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    self.rightButtonStatus = rightButtonWithTitle;
    self.rightCustomButtonTitle = @"登录";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isCountFinished = YES;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:)   name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //创建视图
    [self initRegisterView];
}

//创建视图
- (void)initRegisterView {
    
    //创建公共视图1
    [self initCustomView1WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) ImageName:@"login_phone_icon" Tag:1];
    
    //创建公共视图2
    [self initCustomView2WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) ImageName:@"login_code_icon" Tag:2];
    
    //下一步按钮
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_bgView2.frame)+36*kAdaptationCoefficient, OHScreenW-24*2*kAdaptationCoefficient, 50*kAdaptationCoefficient)];
    [_nextButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    _nextButton.layer.cornerRadius = 4;
    _nextButton.enabled = NO;
    [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
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
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView2.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView2.frame)-(CGRectGetWidth(iconImageView.frame)+8*kAdaptationCoefficient)-100*kAdaptationCoefficient, 24*kAdaptationCoefficient)];
    _codeTextField.tag = tag;
    _codeTextField.delegate = self;
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.keyboardType = UIKeyboardTypePhonePad;
    _codeTextField.borderStyle = UITextBorderStyleNone;
    _codeTextField.backgroundColor = [UIColor whiteColor];
    [_codeTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _codeTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _codeTextField.textAlignment = NSTextAlignmentLeft;
    _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_bgView2 addSubview:_codeTextField];
    
    //验证码
    NSString *buttonStr = @"获取验证码";
    _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeButton setFrame:CGRectMake(CGRectGetMaxX(_codeTextField.frame), (CGRectGetHeight(_bgView2.frame)-35*kAdaptationCoefficient)/2.0, 100*kAdaptationCoefficient, 30*kAdaptationCoefficient)];
    [_getCodeButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    [_getCodeButton setTitle:buttonStr forState:UIControlStateNormal];
    [_getCodeButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.0*kAdaptationCoefficient];
    _getCodeButton.layer.borderColor = OHColor(153, 153, 153, 1.0).CGColor;
    _getCodeButton.layer.borderWidth = 1;
    _getCodeButton.layer.cornerRadius = 4;
    _getCodeButton.enabled = NO;
    [_getCodeButton addTarget:self action:@selector(getCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView2 addSubview:_getCodeButton];
    
    
    //倒计时
    _timeLabel = [[MZTimerLabel alloc] init];
    _timeLabel.frame = _getCodeButton.bounds;
    _timeLabel.delegate = self;
    _timeLabel.timerType = MZTimerLabelTypeTimer;
    _timeLabel.textColor = kButtonNotEnableClick_TitleColor;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    [_timeLabel setCountDownTime:59.0];
    _timeLabel.timeFormat = @"ss秒后重发";
    _timeLabel.hidden = YES;
    [_getCodeButton addSubview:_timeLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView2.frame)-1, CGRectGetWidth(_bgView2.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView2 addSubview:lineView];
}

//点击下一步按钮
- (void)nextButtonClick {
    
    NSLog(@"下一步");
    NSString *phoneNumberText = [OHCommon removeWhiteSpace:_phoneNumberTextFiled.text];
    NSString *codeText = _codeTextField.text;
    
    NSLog(@"phoneNumberText=%@，codeText=%@",phoneNumberText,codeText);
    
    //验证手机验证码
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"checkVCode" andDic:@{@"mobile":phoneNumberText,@"vCode":codeText} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            OHRegisterStepTwoViewController *registerStepTwoVC = [[OHRegisterStepTwoViewController alloc] init];
            registerStepTwoVC.loginVC = _loginVC;
            registerStepTwoVC.mobileNum = phoneNumberText;
            [self.navigationController pushViewController:registerStepTwoVC animated:YES];
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//点击获取验证码按钮
- (void)getCodeButtonClick {
    
    NSString *phoneNumStr = [OHCommon removeWhiteSpace:_phoneNumberTextFiled.text];
    
    //获取手机验证码
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getVCode" andDic:@{@"mobile":phoneNumStr, @"type":@"1"} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            [_getCodeButton setTitle:@"" forState:UIControlStateNormal];
            [_getCodeButton setTitleColor:OHColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
            [_getCodeButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
            _getCodeButton.enabled = NO;
            
            [_timeLabel start];
            _timeLabel.hidden = NO;
            
            _isCountFinished = NO;
            
            [_codeTextField becomeFirstResponder];
        }
        else {
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


//子类重写点击右侧单个按钮的事件
//点击“登录”按钮
- (void)rightCustomButtonClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    else if ([_codeTextField isFirstResponder]) {
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
    
    UITextField *textfield = [obj object];
    
    if (textfield.tag == 1) {           //手机号输入框
        
        if ([OHCommon validateMobile:[OHCommon removeWhiteSpace:_phoneNumberTextFiled.text]]) {
            
            if (_isCountFinished == YES) {
                
                [_getCodeButton setTitleColor:OHColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
                [_getCodeButton setBackgroundColor:[UIColor whiteColor]];
                _getCodeButton.enabled = YES;
                
            }
            else {
                
                [_getCodeButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
                [_getCodeButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
                _getCodeButton.enabled = NO;
            }
        }
        else {
            
            [_getCodeButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
            [_getCodeButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
            _getCodeButton.enabled = NO;
        }
    }
    
    
    if ([OHCommon validateMobile:[OHCommon removeWhiteSpace:_phoneNumberTextFiled.text]] && ![OHCommon isEmptyOrNull:_codeTextField.text]) {
        
        _nextButton.enabled = YES;
        [_nextButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
    }
    else {
        
        _nextButton.enabled = NO;
        [_nextButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    }
}

#pragma mark - UITextFieldDelegate 代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MZTimerLabelDelegate 代理方法
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    if ([OHCommon validateMobile:[OHCommon removeWhiteSpace:_phoneNumberTextFiled.text]]) {
        
        [_getCodeButton setTitleColor:OHColor(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [_getCodeButton setBackgroundColor:[UIColor whiteColor]];
        _getCodeButton.enabled = YES;
    }
    else {
        
        [_getCodeButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        [_getCodeButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
        _getCodeButton.enabled = NO;
    }
    
    _isCountFinished = YES;
    
    [_timeLabel reset];
    _timeLabel.hidden = YES;
}

//点击屏幕，键盘消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_phoneNumberTextFiled endEditing:YES];
    [_codeTextField endEditing:YES];
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
