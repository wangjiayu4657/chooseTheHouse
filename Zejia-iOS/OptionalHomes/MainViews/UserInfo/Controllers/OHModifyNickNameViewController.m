//
//  OHModifyNickNameViewController.m
//  OptionalHome
//
//  Created by lujun on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHModifyNickNameViewController.h"

@interface OHModifyNickNameViewController ()<UITextFieldDelegate>
{
    UITextField *_nicknameTextField;           //昵称输入框
    UIView *_bgView1;
    UIButton *_modifyButton;                //确认修改按钮
}
@end

@implementation OHModifyNickNameViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_nicknameTextField endEditing:YES];
}

- (void)viewDidLoad {
    
    self.titleStr = @"修改昵称";
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
    [self initModifyNickNameView];
}

- (void)initModifyNickNameView {
    
    //创建公共视图1
    [self initCustomView1WithLogoImageViewFrame:CGRectMake(0, kNaviHeight, OHScreenW, 24*kAdaptationCoefficient) Tag:1];
    
    //确认修改按钮
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modifyButton setFrame:CGRectMake(24*kAdaptationCoefficient, CGRectGetMaxY(_bgView1.frame)+36*kAdaptationCoefficient, OHScreenW-24*2*kAdaptationCoefficient, 50*kAdaptationCoefficient)];
    [_modifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    _modifyButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    _modifyButton.layer.cornerRadius = 4;
    [_modifyButton addTarget:self action:@selector(modifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (![OHCommon isEmptyOrNull:_nicknameTextField.text]) {
        
        [_modifyButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
        [_modifyButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
        _modifyButton.enabled = YES;
    }
    else {
        
        [_modifyButton setBackgroundColor:kButtonNotEnableClick_BackgroundColor];
        [_modifyButton setTitleColor:kButtonNotEnableClick_TitleColor forState:UIControlStateNormal];
        _modifyButton.enabled = NO;
    }
    [self.view addSubview:_modifyButton];
}

//创建公共视图1
- (void)initCustomView1WithLogoImageViewFrame:(CGRect)frame Tag:(NSInteger)tag {
    
    //底层视图
    _bgView1 = [[UIView alloc] init];
    _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+24*kAdaptationCoefficient, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
    _bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView1];
    
    //新密码label
    NSString *phoneLabelStr = @"昵 称:";
    CGSize size = [phoneLabelStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 40*kAdaptationCoefficient) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*kAdaptationCoefficient]} context:nil].size;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width+8, 40*kAdaptationCoefficient)];
    phoneLabel.text = phoneLabelStr;
    phoneLabel.textColor = OHColor(51, 51, 51, 1.0);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    [_bgView1 addSubview:phoneLabel];
    
    
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+8*kAdaptationCoefficient, (CGRectGetHeight(_bgView1.frame)-24*kAdaptationCoefficient)/2.0, CGRectGetWidth(_bgView1.frame)-(CGRectGetWidth(phoneLabel.frame)+8*kAdaptationCoefficient), 24*kAdaptationCoefficient)];
    _nicknameTextField.tag = tag;
    _nicknameTextField.delegate = self;
    _nicknameTextField.text = self.nickName;
    _nicknameTextField.placeholder = @"请输入昵称";
    _nicknameTextField.keyboardType = UIKeyboardTypeDefault;
    _nicknameTextField.borderStyle = UITextBorderStyleNone;
    _nicknameTextField.backgroundColor = [UIColor whiteColor];
    [_nicknameTextField setValue:OHColor(187, 187, 187, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    _nicknameTextField.font = [OHFont systemFontOfSize:16*kAdaptationCoefficient];
    _nicknameTextField.textAlignment = NSTextAlignmentLeft;
    _nicknameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nicknameTextField becomeFirstResponder];
    [_bgView1 addSubview:_nicknameTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView1.frame)-1, CGRectGetWidth(_bgView1.frame), 1)];
    lineView.backgroundColor = OHColor(187, 187, 187, 1.0);
    [_bgView1 addSubview:lineView];
}

//点击确认修改按钮
- (void)modifyButtonClick {
    
    NSString *nicknameText = _nicknameTextField.text;
    NSLog(@"nicknameText=%@",nicknameText);
    
    //修改用户昵称请求
    [self modifyNickNameRequestWithSseeionId:kSessionId NickName:nicknameText];
}

//修改用户昵称请求
- (void)modifyNickNameRequestWithSseeionId:(NSString *)sessionId NickName:(NSString *)nickname {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"updateNickname" andDic:@{@"sessionId":sessionId,@"nickname":nickname} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            //更新本地NickName
            [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"NickName"];
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            //返回个人信息页，并刷新个人信息页数据
            [self performSelector:@selector(backToUserInfoViewAndReloadData) withObject:nil afterDelay:1.0];
        }
        else {
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//返回个人信息页，并刷新个人信息页数据
- (void)backToUserInfoViewAndReloadData {
    
    //刷新个人信息页数据
    if ([self.delegate respondsToSelector:@selector(reloadUserInfoDataComeFromModifyNickNameVC)]) {
        
        [self.delegate reloadUserInfoDataComeFromModifyNickNameVC];
    }

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
    CGFloat moveHeight = keyboardHeight - (OHScreenH-CGRectGetMaxY(_bgView1.frame));
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (moveHeight >= 0) {
            
            _bgView1.frame = CGRectMake(24*kAdaptationCoefficient, kNaviHeight+24*kAdaptationCoefficient-moveHeight, OHScreenW-24*kAdaptationCoefficient*2, 40*kAdaptationCoefficient);
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
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)obj {
    
    if (![OHCommon isEmptyOrNull:_nicknameTextField.text]) {
        
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
    
    [_nicknameTextField endEditing:YES];
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
