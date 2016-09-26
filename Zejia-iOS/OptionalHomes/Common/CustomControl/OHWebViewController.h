//
//  OHWebViewController.h
//  OptionalHome
//
//  Created by haili on 16/8/5.
//  Copyright © 2016年 haili. All rights reserved.
//  webView

#import "OHBaseViewController.h"

@interface OHWebViewController : OHBaseViewController<UIWebViewDelegate>
{
    UIWebView *m_webView;
    NSURL* _url;
    NSString *_title;
}
@property(nonatomic,copy)NSString *isType;
-(instancetype)initWithURL:(NSURL*)url andTitle:(NSString *)title;
@end
