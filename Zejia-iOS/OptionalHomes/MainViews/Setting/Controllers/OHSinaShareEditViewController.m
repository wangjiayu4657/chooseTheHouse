//
//  OHSinaShareEditViewController.m
//  ClockClassroom
//
//  Created by lujun on 15/12/29.
//  Copyright © 2015年 EjuChina. All rights reserved.
//

#import "OHSinaShareEditViewController.h"
#import "UMSocial.h"
#import "UMSocialDataService.h"

@interface OHSinaShareEditViewController ()
{
    UITextView *_shareContentTextView;      //分享的内容编辑框
    UILabel *_wordNumLabel;                 //剩余字数Label
}
@end

@implementation OHSinaShareEditViewController

- (void)viewDidLoad {
    
    self.titleStr = @"意见反馈";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自定义分享视图
    [self initShareEditView];
}

//重写子类方法（点击返回按钮）
- (void)baseBackButtonClick {

    [self.navigationController popViewControllerAnimated:YES];
}

//自定义分享视图
- (void)initShareEditView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, kNaviHeight+12, OHScreenW-12*2, 143*kAdaptationCoefficient)];
    bgView.backgroundColor = OHColor(226, 226, 226, 1.0);
    [self.view addSubview:bgView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(6, 6, bgView.frame.size.width-6*2, 130*kAdaptationCoefficient)];
    shareView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:shareView];
    
    _shareContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(6, 10, shareView.frame.size.width-6*2, 90*kAdaptationCoefficient)];
    _shareContentTextView.delegate = self;
    _shareContentTextView.backgroundColor = [UIColor whiteColor];
    _shareContentTextView.text = self.shareContent;
    _shareContentTextView.textColor = [UIColor grayColor];
    _shareContentTextView.font = [OHFont systemFontOfSize:15*kAdaptationCoefficient];
    _shareContentTextView.returnKeyType = UIReturnKeyDefault;
    _shareContentTextView.keyboardType = UIKeyboardTypeDefault;
    [shareView addSubview:_shareContentTextView];
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(12, bgView.frame.origin.y+bgView.frame.size.height+34*kAdaptationCoefficient, OHScreenW-12*2, 50*kAdaptationCoefficient)];
    [shareButton setBackgroundColor:kButtonEnableClick_BackgroundColor];
    [shareButton setTitle:@"确定" forState:UIControlStateNormal];
    [shareButton setTitleColor:kButtonEnableClick_TitleColor forState:UIControlStateNormal];
    shareButton.titleLabel.font = [OHFont systemFontOfSize:17*kAdaptationCoefficient];
    shareButton.layer.cornerRadius = 4;
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    _wordNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareView.frame.size.width-150-6, _shareContentTextView.frame.origin.y+_shareContentTextView.frame.size.height+5, 150, 20)];
    _wordNumLabel.textAlignment = NSTextAlignmentRight;
    _wordNumLabel.text = [NSString stringWithFormat:@"还可输入%lu个字",135-self.shareContent.length];
    _wordNumLabel.textColor = [UIColor grayColor];
    _wordNumLabel.font = [OHFont systemFontOfSize:13*kAdaptationCoefficient];
    [shareView addSubview:_wordNumLabel];
}

//点击分享按钮
- (void)shareButtonClick {
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareContentTextView.text image:self.shareImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [OHCommon showWeakTips:@"分享成功" View:self.view];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.0];
        }
        else {
            
            [OHCommon showWeakTips:@"分享失败" View:self.view];
        }
    }];
}

#pragma mark - UITextViewDelegate 代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > 135) {
        
        textView.text = [textView.text substringToIndex:135];
    }
    if (135-number < 0) {
        _wordNumLabel.text = [NSString stringWithFormat:@"还可输入%@个字",@"0"];
    }
    else {
        _wordNumLabel.text = [NSString stringWithFormat:@"还可输入%lu个字",135-number];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {   //按下return键，不换行且让键盘消失
        
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *TextStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (TextStr.length > 135) {    //限制最大字数为135
        
        return NO;
    }
    else {
        
        _wordNumLabel.text = [NSString stringWithFormat:@"还可输入%lu个字",135-TextStr.length];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_shareContentTextView endEditing:YES];
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
