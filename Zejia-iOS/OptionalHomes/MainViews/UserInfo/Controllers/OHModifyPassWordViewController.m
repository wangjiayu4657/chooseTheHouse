//
//  OHModifyPassWordViewController.m
//  OptionalHome
//
//  Created by lujun on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHModifyPassWordViewController.h"

@interface OHModifyPassWordViewController ()<UITextFieldDelegate>
{
    UITextField *_oldPWTextField;           //旧密码输入框
    UITextField *_newPWTextField;           //新密码输入框
    UITextField *_newPWAgainTextField;      //重复密码输入框
    
    UIView *_bgView1;
    UIView *_bgView2;
    UIView *_bgView3;
    UIButton *_modifyButton;                //确认修改按钮
    
    CGSize _size;                           //标题label的size
}

@end

@implementation OHModifyPassWordViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_oldPWTextField endEditing:YES];
    [_newPWTextField endEditing:YES];
    [_newPWAgainTextField endEditing:YES];
}

- (void)viewDidLoad {
    
    self.titleStr = @"修改密码";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:)   name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //创建视图
    [self initModifyPWView];
}

//创建视图
- (void)initModifyPWView {
    
    //创建公共视图1
    [self initCustomView1WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) Tag:1];
    
    //创建公共视图2
    [self initCustomView2WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) Tag:2];
    
    //创建公共视图3
    [self initCustomView3WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) Tag:3];
    
    //确认修改按钮
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modifyButton setFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_bgView3.frame)+36*kAdaptationCoefficient, OHScreenW-24*2*kAdaptationCoefficient, 50*kAdaptationCoefficient)];
    [_modifyButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    [_modifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [_modifyButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
    _modifyButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    _modifyButton.layer.cornerRadius = 4;
    _modifyButton.enabled = NO;
    [_modifyButton addTarget:self action:@selector(modifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_modifyButton];
}

//创建公共视图1
- (void)initCustomView1WithLogoImageViewFrame:(CGRect)frame Tag:(NSInteger)tag {
    
    //底层视图
    _bgView1 = [[UIView alloc] init];
    _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+24*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView1];
    
    //旧密码label
    NSString *phoneLabelStr = @"旧 密 码:";
    _size = [phoneLabelStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 40*kAdaptationCoefficient) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*kAdaptationCoefficient]} context:nil].size;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size.width+8*kAdaptationCoefficient, 40*kAdaptationCoefficient)];
    phoneLabel.text = phoneLabelStr;
    phoneLabel.textColor = OHColor(51, 51, 51, 1.0);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [_bgView1 addSubview:phoneLabel];
    
    
    _oldPWTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView1.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView1.frame)-(CGRectGetWidth(phoneLabel.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _oldPWTextField.tag = tag;
    _oldPWTextField.delegate = self;
    _oldPWTextField.placeholder = @"请输入旧密码";
    _oldPWTextField.keyboardType = UIKeyboardTypeDefault;
    _oldPWTextField.borderStyle = UITextBorderStyleNone;
    _oldPWTextField.backgroundColor = [UIColor whiteColor];
    [_oldPWTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _oldPWTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _oldPWTextField.textAlignment = NSTextAlignmentLeft;
    _oldPWTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _oldPWTextField.secureTextEntry = YES;
    [_bgView1 addSubview:_oldPWTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView1.frame)-1, CGRectGetWidth(_bgView1.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView1 addSubview:lineView];
}

//创建公共视图2
- (void)initCustomView2WithLogoImageViewFrame:(CGRect)frame Tag:(NSInteger)tag {
    
    //底层视图
    _bgView2 = [[UIView alloc] init];
    _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView2];
    
    //新密码label
    NSString *codeLabelStr = @"新 密 码:";
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size.width+8*kAdaptationCoefficient, 40*kAdaptationCoefficient)];
    codeLabel.text = codeLabelStr;
    codeLabel.textColor = OHColor(51, 51, 51, 1.0);
    codeLabel.textAlignment = NSTextAlignmentLeft;
    codeLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [_bgView2 addSubview:codeLabel];
    
    
    _newPWTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeLabel.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView2.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView2.frame)-(CGRectGetWidth(codeLabel.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _newPWTextField.tag = tag;
    _newPWTextField.delegate = self;
    _newPWTextField.placeholder = @"请输入新密码";
    _newPWTextField.keyboardType = UIKeyboardTypeDefault;
    _newPWTextField.borderStyle = UITextBorderStyleNone;
    _newPWTextField.backgroundColor = [UIColor whiteColor];
    [_newPWTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _newPWTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _newPWTextField.textAlignment = NSTextAlignmentLeft;
    _newPWTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newPWTextField.secureTextEntry = YES;
    [_bgView2 addSubview:_newPWTextField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView2.frame)-1, CGRectGetWidth(_bgView2.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView2 addSubview:lineView];
}

- (void)initCustomView3WithLogoImageViewFrame:(CGRect)frame Tag:(NSInteger)tag {
    
    //底层视图
    _bgView3 = [[UIView alloc] init];
    _bgView3.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40*2+24*2)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView3];
    
    //重复密码label
    NSString *codeLabelStr = @"重复密码:";
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size.width+8*kAdaptationCoefficient, 40*kAdaptationCoefficient)];
    codeLabel.text = codeLabelStr;
    codeLabel.textColor = OHColor(51, 51, 51, 1.0);
    codeLabel.textAlignment = NSTextAlignmentLeft;
    codeLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [_bgView3 addSubview:codeLabel];
    
    
    _newPWAgainTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeLabel.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView3.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView3.frame)-(CGRectGetWidth(codeLabel.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _newPWAgainTextField.tag = tag;
    _newPWAgainTextField.delegate = self;
    _newPWAgainTextField.placeholder = @"请再次输入新密码";
    _newPWAgainTextField.keyboardType = UIKeyboardTypeDefault;
    _newPWAgainTextField.borderStyle = UITextBorderStyleNone;
    _newPWAgainTextField.backgroundColor = [UIColor whiteColor];
    [_newPWAgainTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _newPWAgainTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _newPWAgainTextField.textAlignment = NSTextAlignmentLeft;
    _newPWAgainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newPWAgainTextField.secureTextEntry = YES;
    [_bgView3 addSubview:_newPWAgainTextField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView3.frame)-1, CGRectGetWidth(_bgView3.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView3 addSubview:lineView];
}

//点击确认修改按钮
- (void)modifyButtonClick {
    
    NSString *oldPWText = _oldPWTextField.text;
    NSString *newPWText = _newPWTextField.text;
    NSString *newPWAgainText = _newPWAgainTextField.text;
    NSLog(@"oldPWText=%@，newPWText=%@，newPWAgainText=%@",oldPWText,newPWText,newPWAgainText);
    
    if ([OHCommon isEmptyOrNull:oldPWText]) {
        
        [OHCommon showWeakTips:@"旧密码不能为空" View:self.view];
    }
    else if (![newPWText isEqualToString:newPWAgainText]) {
        
        [OHCommon showWeakTips:@"两次输入的密码不一致" View:self.view];
    }
    else {
        
        //确认修改
        //修改密码请求
        [self ModifyPassWordRequestWithSessionId:kSessionId Mobile:kMobile oldPassWord:oldPWText NewPassWord:newPWText];
    }
}

//修改密码请求
- (void)ModifyPassWordRequestWithSessionId:(NSString *)sessionId Mobile:(NSString *)mobile oldPassWord:(NSString *)oldPwd NewPassWord:(NSString *)newPwd {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"modifyPwd" andDic:@{@"sessionId":sessionId,@"mobile":mobile,@"oldPwd":oldPwd,@"pwd":newPwd,@"type":@"1"} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            //返回个人信息页
            [self performSelector:@selector(backToUserInfoView) withObject:nil afterDelay:1.0];
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//返回个人信息页
- (void)backToUserInfoView {
    
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
    CGFloat moveHeight = keyboardHeight - (OHScreenH-CGRectGetMaxY(_bgView3.frame));
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (moveHeight >= 0) {
            
            _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+24*kAdaptationCoefficient-moveHeight, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
            _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
            _bgView3.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40*2+24*2)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
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
        
        _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+24*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
        _bgView2.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40+24)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
        _bgView3.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+(24+40*2+24*2)*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)obj {
    
    if (![OHCommon isEmptyOrNull:_oldPWTextField.text] && ![OHCommon isEmptyOrNull:_newPWTextField.text] && ![OHCommon isEmptyOrNull:_newPWAgainTextField.text]) {
        
        _modifyButton.enabled = YES;
        [_modifyButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
        [_modifyButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
    }
    else {
        
        _modifyButton.enabled = NO;
        [_modifyButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        [_modifyButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
    }
}

#pragma mark - UITextFieldDelegate 代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕，键盘消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_oldPWTextField endEditing:YES];
    [_newPWTextField endEditing:YES];
    [_newPWAgainTextField endEditing:YES];
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
