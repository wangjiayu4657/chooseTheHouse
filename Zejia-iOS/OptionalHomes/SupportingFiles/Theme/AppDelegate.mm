//
//  AppDelegate.m
//  OptionalHome
//
//  Created by haili on 16/7/18.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
//#import <Bugtags/Bugtags.h>

#import <CoreLocation/CoreLocation.h>
#import "OHLeftContentViewcontroller.h"
#import "OHHomeViewController.h"
#import "OHGuideViewController.h"
#import "BaiduMapAPI_Base/BMKMapManager.h"
#import "OHCommunityViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate, WeiboSDKDelegate, WXApiDelegate, CLLocationManagerDelegate, BMKGeneralDelegate>
{
    CLLocationManager *_locationManager;    //定位
}

@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if (kSessionId && [kInHome integerValue]==0) {
        OHCommunityViewController *communityVC = [[OHCommunityViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:communityVC];
    }
    else{
        OHHomeViewController *mainVC = [[OHHomeViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    }
    
    OHLeftContentViewcontroller *leftVC = [[OHLeftContentViewcontroller alloc] init];
    self.LeftSlideVC = [[OHLeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    [self.LeftSlideVC setPanEnabled:NO];
    self.window.rootViewController = self.LeftSlideVC;
    
    //加载引导页
    [self isFirstLaunch];
    
    //检测网络状态
    [self checkNetworkReachabilityStatus];
    
    //第三方SDK设置
    [self appSetting:launchOptions];
    
    //判断定位功能是否已开启
    [self locationIsOn];
    
    //启动百度地图引擎
    [self startMapManager];
    
    //获取最新版本号请求
    [self getNewestVersion];

    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    NSLog(@"Scheme: %@", [url scheme]);
//    NSLog(@"Host: %@", [url host]);
//    NSLog(@"Port: %@", [url port]);
//    NSLog(@"Path: %@", [url path]);
//    NSLog(@"Relative path: %@", [url relativePath]);
//    NSLog(@"Path components as array: %@", [url pathComponents]);
//    NSLog(@"Parameter string: %@", [url parameterString]);
//    NSLog(@"Query: %@", [url query]);
//    NSLog(@"Fragment: %@", [url fragment]);
//    NSLog(@"User: %@", [url user]);
//    NSLog(@"Password: %@", [url password]);
    
    if ([[url scheme] compare:[NSString stringWithFormat:@"tencent%@",Tencent_AppID] options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    {
        return [TencentOAuth HandleOpenURL:url];    //调起QQ登录
    }
//    else if ([[url scheme] compare:[NSString stringWithFormat:@"QQ%@",Tencent_AppID_16] options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
//    {
//        return [UMSocialSnsService handleOpenURL:url];    //调起QQ分享
//    }
    else if ([[url scheme] compare:WeChat_AppID options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    {
        if ([url.host isEqualToString:@"oauth"]) {
            //调起微信登录
            return [WXApi handleOpenURL:url delegate:self];
        }
//        else if ([url.host isEqualToString:@"platformId=wechat"]){
//            //调起友盟分享(微信)
//            return  [UMSocialSnsService handleOpenURL:url];
//        }
//        else if ([url.host isEqualToString:@"pay"]) {
//            //调起微信支付函数
//            return [WXApi handleOpenURL:url delegate:self];
//        }
    }
    else if ([[url scheme] compare:[NSString stringWithFormat:@"wb%@",Sina_AppKey] options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    {
        if ([[Singleton shareSingleton].sinaType isEqualToString:@"gotoUnionLogin"] || [[Singleton shareSingleton].sinaType isEqualToString:@"gotoBind"])
        {
            //新浪微博登录
            return [WeiboSDK handleOpenURL:url delegate:self];
        }
        else if ([[Singleton shareSingleton].sinaType isEqualToString:@"gotoShare"])
        {
            //调起友盟分享(新浪微博)
            return  [UMSocialSnsService handleOpenURL:url];
        }
    }
    return YES;
}

- (void)startMapManager {
    // 主引擎
    _mapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [_mapManager start:KBaiDuMapKey  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 第三方SDK设置
- (void)appSetting:(NSDictionary *)launchOptions {
    
    //微博联合登陆设置
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:Sina_AppKey];
    
    //向微信注册
    [WXApi registerApp:WeChat_AppID];
    
    //初始化数据统计SDK
    [XXReporter isOpenTestLog:YES];
    [XXReporter startWithAppID:@"1608161514" channelID:@"AppStore"];
    [XXReporter crashLog];
    
    //由于苹果审核政策需求，要求对未安装客户端平台进行隐藏，在设置QQ、微信AppID之前调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:nil];

    //友盟分享
    [UMSocialData setAppKey:UM_Appkey];

    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:Sina_AppKey secret:Sina_AppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //BugTags
//    [Bugtags startWithAppKey:@"a03e403927041de2bb2f16cc7c319314" invocationEvent:BTGInvocationEventBubble];
}


//判断【设置】>【隐私】>【定位服务】是否已开启
- (void)locationIsOn {
    
    //判断定位是否已开启
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {       //定位服务未开启
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"允许“择家”在您使用该应用时访问您的位置吗？" message:@"择家使用您的位置，为您提供更精准的选房服务，请在“设置”中打开" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"去设置", nil];
        alertView.tag = 1;
        [alertView show];
    }
    else {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 500;
        if ([INTERFACE_OS floatValue] >= 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];  //开始定位
    }
}

#pragma mark - CLLocationManagerDelegate 代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"status=%d",status);
    
    if ([INTERFACE_OS floatValue] >= 8.0) {
        
        if (status == kCLAuthorizationStatusDenied) {       //不允许定位时，清除本地经纬度
            
            if (![OHCommon isEmptyOrNull:KLATITUDE] || ![OHCommon isEmptyOrNull:KLONGITUDE]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
            }
        }
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse | status == kCLAuthorizationStatusAuthorizedAlways | status == kCLAuthorizationStatusDenied) {
            
            
        }
    }
    else {      //iOS7.0-8.0
        
        if (status == kCLAuthorizationStatusDenied) {       //不允许定位时，清除本地经纬度
            
            if (![OHCommon isEmptyOrNull:KLATITUDE] || ![OHCommon isEmptyOrNull:KLONGITUDE]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
            }
        }
        if (status == kCLAuthorizationStatusAuthorizedAlways | status == kCLAuthorizationStatusDenied) {
            
            
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    NSLog(@"纬度：%f, 经度：%f",coordinate.latitude, coordinate.longitude);
    
    NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIAlertViewDelegate 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {           //定位授权AlertView
        
        if (buttonIndex == 1) {
            
            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];        //跳转到【设置】>【隐私】>【定位服务】
            }
            
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            
//            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                
//                [[UIApplication sharedApplication] openURL:url];        //跳转到“设置”中的“定位服务”
//            }
        }
    }
    else if (alertView.tag == 2) {      //升级版本AlertView
        
        if (buttonIndex == 1) {
            
            //跳转到AppStore
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreURL]];
        }
    }
}

#pragma marks - 新浪微博 代理方法
/**
 *  收到一个来自微博客户端程序的请求
 *  收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 *
 *  @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    if ([request isKindOfClass:WBAuthorizeResponse.class])
    {
        NSLog(@"sdkVersion= %@",request.sdkVersion);
    }
}


/**
 *  收到一个来自微博客户端程序的响应
 *  收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 *
 *  @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString * accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString * userID = [(WBAuthorizeResponse *)response userID];
        
        if (accessToken!=nil && ![accessToken isEqualToString:@""]) {
            
            //新浪微博登录成功后，保存accessToken和userID，做后续操作待定
            NSDictionary * dic =[NSDictionary dictionaryWithObjects:@[accessToken,userID] forKeys:@[@"accessToken",@"userID"]];
            
            if ([[Singleton shareSingleton].sinaType isEqualToString:@"gotoUnionLogin"]) {  //登录
                [[NSNotificationCenter defaultCenter] postNotificationName:SinaLoginSuccess object:dic];
            }
            else if ([[Singleton shareSingleton].sinaType isEqualToString:@"gotoBind"]) {   //绑定
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SinaBindSuccess object:dic];
            }
        }
        
    }
}


/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 *  收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 *  可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 *
 *  @param req 具体请求内容，是自动释放的
 */
#pragma mark - 微信 代理方法
-(void) onReq:(BaseReq*)req {
    
    NSLog(@"req= %@", req);
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 *  收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 *  可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 *
 *  @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    
    NSLog(@"class=%@, resp=%@",[resp class], resp);
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {        //微信登录
        
        if (resp.errCode == 0) {   //ErrCode=0时，用户换取access_token所使用的code才是有效的
            
            SendAuthResp *sendAuthResp = (SendAuthResp *)resp;
            NSLog(@"code = %@",sendAuthResp.code);
            
            //获取accessToken,openid
            NSString *UrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChat_AppID,WeChat_AppSecret,sendAuthResp.code];
            NSURL *url = [NSURL URLWithString:UrlStr];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *respDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];   //NSData转成NSDictionary
            
            //获取用户信息
            //        https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
            NSString *UserInfoStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[respDic objectForKey:@"access_token"], [respDic objectForKey:@"openid"]];
            NSURL *InfoUrl = [NSURL URLWithString:UserInfoStr];
            NSURLRequest *InfoRequest = [[NSURLRequest alloc] initWithURL:InfoUrl];
            NSData *InfoData = [NSURLConnection sendSynchronousRequest:InfoRequest returningResponse:nil error:nil];
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:InfoData options:NSJSONReadingMutableContainers error:nil];   //NSData转成NSDictionary
            
            if ([[Singleton shareSingleton].wechatType isEqualToString:@"gotoLogin"]) {     //登录
                //发布通知，微信获取到用户信息后，发通知给登录页面，并把infoDic传过去
                [[NSNotificationCenter defaultCenter] postNotificationName:WechatLoginSuccess object:infoDic];
            }
            else if ([[Singleton shareSingleton].wechatType isEqualToString:@"gotoBind"]) {     //绑定
                
                //发布通知，微信获取到用户信息后，发通知给绑定页面，并把infoDic传过去
                [[NSNotificationCenter defaultCenter] postNotificationName:WeChatBindSuccess object:infoDic];
            }
        }
    }
}

- (void)isFirstLaunch
{
    //判断是否是第一次 使用
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        //做个标记,已经不是第一次
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次使用的话,就进入引导页
        [self showGuideView];
    }
}
//引导页
- (void)showGuideView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        guideViewController = [[OHGuideViewController alloc] init];
        [self.window.rootViewController.view addSubview:guideViewController.view];
    }
}

//监测网络状态
- (void)checkNetworkReachabilityStatus {
    
    //创建网络监控的单例对象
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    
    //开始监控网络状态
    [networkManager startMonitoring];
    
    //当网络状态改变了, 就会调用这个block
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"123123未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"123123没有网络(断网)");
                [OHCommon setDefaultsObject:@"NotReachable" forKey:@"isNetwork"];
                [OHCommon showWeakTips:@"您的网络已断开，请检查您的网络！" View:self.window];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"123123手机自带网络");
                [OHCommon setDefaultsObject:@"ReachableViaWWAN" forKey:@"isNetwork"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"123123WIFI");
                [OHCommon setDefaultsObject:@"ReachableViaWiFi" forKey:@"isNetwork"];
                break;
        }
    }];
}


//获取最新版本号请求
- (void)getNewestVersion {
    
    [AFServer requestDataWithUrl:@"getVersion" andDic:nil completion:^(NSDictionary *dic) {
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            NSDictionary *responseDic = [dic objectForKey:@"response"];
            NSString *appDesc = [NSString stringWithFormat:@"%@",[responseDic objectForKey:@"desc"]];
            
            if (kAppVersion == nil) {
                
                //保存APP版本号、标签版本号、筛选条件版本号
                [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"version"] forKey:@"appVersion"];
                [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"tagVersion"] forKey:@"tagVersion"];
                [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"filterVersion"] forKey:@"filterVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else {
                
                if (![[responseDic objectForKey:@"version"] isEqualToString:kAppVersion]) {
                    
                    //重新保存APP版本号、标签版本号、筛选条件版本号
                    [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"version"] forKey:@"appVersion"];
                    [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"tagVersion"] forKey:@"tagVersion"];
                    [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"filterVersion"] forKey:@"filterVersion"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //以“,”英文逗号作为分行符
                    NSString *descStr = [appDesc stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:descStr delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即更新", nil];
                    alertView.tag = 2;
                    [alertView show];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [OHCommon removeWhiteSpace:myToken];
      //把获取到的deviceToken存到NSUserDefaults中
    [OHCommon setDefaultsObject:myToken forKey:@"DeviceToken"];
    
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n",myToken);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
