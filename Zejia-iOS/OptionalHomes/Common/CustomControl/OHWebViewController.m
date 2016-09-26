//
//  OHWebViewController.m
//  OptionalHome
//
//  Created by haili on 16/8/5.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHWebViewController.h"

@interface OHWebViewController()
{
    NSTimer *_myTimer;
    NSInteger _timeCount;
}
@end

@implementation OHWebViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //开启定时器
    [_myTimer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //关闭定时器
    [_myTimer setFireDate:[NSDate distantFuture]];
}

-(instancetype)initWithURL:(NSURL*)url andTitle:(NSString *)title{
    
    self = [super init];
    _url = url;
    _title = title;
    return self;
}

- (void)viewDidLoad {
    
    self.titleStr = _title;
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    m_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight)];
    m_webView.delegate=self;
    [m_webView setScalesPageToFit:YES];
    [self.view addSubview:m_webView];
    NSURLRequest *request=[NSURLRequest requestWithURL:_url];
    [m_webView loadRequest:request];
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideHUD) userInfo:nil repeats:YES];
    _timeCount = 5;
}

- (void)hideHUD {
    
    _timeCount--;
    if (_timeCount == 0) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
