//
//  OHUserInfoViewController.m
//  OptionalHome
//
//  Created by lujun on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHUserInfoViewController.h"
#import "OHUserInfoTableViewCell.h"
#import "OHModifyNickNameViewController.h"
#import "OHModifyPassWordViewController.h"
#import "OHHomeViewController.h"

#import "OHUserInfoModel.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WeiboSDK.h"

@interface OHUserInfoViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, OHModifyNickNameViewControllerDelegate, TencentSessionDelegate, WBHttpRequestDelegate, TencentApiInterfaceDelegate>
{
    TencentOAuth *tencentOAuth;
    NSString *openID;
    
    UITableView *_userInfoTableView;                    //个人信息页tableview
    OHUserInfoModel *_userInfoModel;
}
@end

@implementation OHUserInfoViewController

- (void)dealloc {
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.titleStr = @"个人信息";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = OHColor(236, 236, 236, 1.0);
    
    //设置黄色背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, 300*kAdaptationCoefficient)];
    bgView.backgroundColor = kButtonEnableClick_BackgroundColor;
    [self.view addSubview:bgView];
    
    //创建设置页TableView
    [self initUserInfoTableView];
    
    //获取用户信息请求
    [self getUserInfoRequestWithSessionId:kSessionId];
    
    //注册通知（监听新浪微博绑定成功）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaBindSuccess:) name:SinaBindSuccess object:nil];
    
    //注册通知（监听微信绑定成功）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatBindSuccess:) name:WeChatBindSuccess object:nil];
}

//获取用户信息请求
- (void)getUserInfoRequestWithSessionId:(NSString *)sessionId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getUserInfo" andDic:@{@"sessionId":sessionId} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            _userInfoModel = [OHUserInfoModel mj_objectWithKeyValues:[dic objectForKey:@"response"]];
            //保存用户手机号到本地
            [[NSUserDefaults standardUserDefaults] setObject:_userInfoModel.mobile forKey:@"Mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        [_userInfoTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//创建设置页TableView
- (void)initUserInfoTableView {
    
    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight) style:UITableViewStyleGrouped];
    _userInfoTableView.backgroundColor = [UIColor clearColor];
    _userInfoTableView.delegate = self;
    _userInfoTableView.dataSource = self;
    _userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userInfoTableView.showsVerticalScrollIndicator = NO;
    //去掉tableview底部多余的分割线
    _userInfoTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_userInfoTableView];
}

#pragma mark - UITableViewDataSource 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 3;
    }
    else if (section == 1) {
        
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid1 = @"cellID1";
    
    OHUserInfoTableViewCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:cellid1];
    if (userInfoCell == nil){
        
        userInfoCell = [[OHUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
    }
    userInfoCell.backgroundColor = [UIColor whiteColor];
    userInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;        //设置cell被选中时的类型
    
    //快速移除原有cell中的数据
    [userInfoCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [userInfoCell OHUserInfoTableViewCellConfigWithUserInfo:_userInfoModel IndexPath:indexPath];
    
    return userInfoCell;
}

#pragma mark - UITableViewDelegate 代理方法
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = OHColor(236, 236, 236, 1.0);
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*kAdaptationCoefficient, 0, 120, 30*kAdaptationCoefficient)];
        tipsLabel.text = @"账号绑定";
        tipsLabel.textColor = OHColor(153, 153, 153, 1.0);
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        [lineView addSubview:tipsLabel];
        
        return lineView;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = OHColor(236, 236, 236, 1.0);
        return lineView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 30*kAdaptationCoefficient;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 16*kAdaptationCoefficient;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中第%ld个分区的第%ld行",(long)indexPath.section, (long)indexPath.row);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {           //头像
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            actionSheet.delegate = self;
            [actionSheet addButtonWithTitle:@"拍照"];
            [actionSheet addButtonWithTitle:@"从手机相册中选择"];
            [actionSheet addButtonWithTitle:@"取消"];
            actionSheet.cancelButtonIndex = 2;
            [actionSheet showInView:self.view];
            
        }
        else if (indexPath.row == 1) {      //昵称
            
            OHModifyNickNameViewController *modifyNickNameVC = [[OHModifyNickNameViewController alloc] init];
            modifyNickNameVC.delegate = self;
            modifyNickNameVC.nickName = _userInfoModel.nickname;
            [self.navigationController pushViewController:modifyNickNameVC animated:YES];
        }
        else if (indexPath.row == 2) {      //修改密码
            
            if (![OHCommon isEmptyOrNull:_userInfoModel.mobile]) {
                
                OHModifyPassWordViewController *modifyPassWordVC = [[OHModifyPassWordViewController alloc] init];
                [self.navigationController pushViewController:modifyPassWordVC animated:YES];
            }
            else {
                
                [OHCommon showWeakTips:@"第三方登录，不可修改密码！" View:self.view];
            }
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {           //微信
            
            [Singleton shareSingleton].wechatType = @"gotoBind"; //单例
            //授权登录接入
            //构造SendAuthReq结构体
            SendAuthReq* req =[[SendAuthReq alloc ] init ];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"shizhongjiaoshi_987654321" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        }
        else if (indexPath.row == 2) {      //QQ
            
            tencentOAuth = [[TencentOAuth alloc] initWithAppId:Tencent_AppID andDelegate:self];
            NSArray* permissions = [NSArray arrayWithObjects:
                                    kOPEN_PERMISSION_GET_USER_INFO,
                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                    nil];
            [tencentOAuth authorize:permissions inSafari:YES];
        }
        else if (indexPath.row == 3) {      //微博
            
            [Singleton shareSingleton].sinaType = @"gotoBind"; //单例
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = @"http://sns.whalecloud.com/sina2/callback";
            request.userInfo = @{
                                 @"SSO_From" : @"SendMessageToWeiboViewController",
                                 @"Other_Info_1" : [NSNumber numberWithInt:123],
                                 @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                                 @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                                 };
            [WeiboSDK sendRequest:request];
        }
    }
    
    //行被选中后，自动变回反选状态的方法,此时deselect的代理方法不再被调用
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 150*kAdaptationCoefficient;
        }
    }
    return 52*kAdaptationCoefficient;
}

#pragma mark - OHModifyNickNameViewControllerDelegate 代理方法
//刷新个人信息页数据
- (void)reloadUserInfoDataComeFromModifyNickNameVC {
    
    [self getUserInfoRequestWithSessionId:kSessionId];
}

#pragma mark - QQ联合登录 代理方法
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (cancelled) {
        
        NSLog(@"用户取消登录");
    }
    else {
        
        NSLog(@"登录失败");
    }
}

- (void)tencentDidLogin{
    
    if (tencentOAuth.accessToken && [tencentOAuth.accessToken length] != 0) {
        
        openID = tencentOAuth.openId;
        
        if (![tencentOAuth getUserInfo]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，获取token失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - QQ登录获取用户信息 委托方法
- (void)getUserInfoResponse:(APIResponse*) response {
    
    if (response.retCode == URLREQUEST_SUCCEED) {  //获取用户信息成功
        
        //设置账号绑定请求
        [self BindAccountWithSessionId:kSessionId Type:@"qq" OpenId:openID];
    }
    else { //获取用户信息失败
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)tencentDidNotNetWork{
    
    NSLog(@"无网络连接");
}

//新浪微博登录成功，回掉通知
- (void)sinaBindSuccess:(NSNotification*)notification {
    
    NSDictionary *dic = notification.object;
    openID = [dic objectForKey:@"accessToken"];
    NSString * uid = [dic objectForKey:@"userID"];
    
    NSDictionary *dicParam =[NSDictionary dictionaryWithObjects:@[uid,openID,Sina_AppKey] forKeys:@[@"uid",@"access_token",@"source"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dicParam delegate:self withTag:nil];
}

#pragma mark - 新浪微博登录 代理方法
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取微博用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)respons {
    
}

#pragma mark - 新浪微博联合登录 代理方法
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *dic = [OHCommon dictionaryWithJsonString:result];
    
    if (dic == nil || ![dic isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSString *uid = [dic objectForKey:@"id"];
    
    //设置账号绑定请求
    [self BindAccountWithSessionId:kSessionId Type:@"weibo" OpenId:uid];
}

//微信登录成功通知
- (void)weChatBindSuccess:(NSNotification *)notification {
    
    NSDictionary *dic = notification.object;
    openID = [dic objectForKey:@"openid"];
    
    //设置账号绑定请求
    [self BindAccountWithSessionId:kSessionId Type:@"weixin" OpenId:openID];
}

//设置账号绑定请求
- (void)BindAccountWithSessionId:(NSString *)sessionId Type:(NSString *)type OpenId:(NSString *)openId {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"updateBindAccount" andDic:@{@"sessionId":sessionId,@"type":type,@"value":openId} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            //刷新个人信息页数据
            [self getUserInfoRequestWithSessionId:kSessionId];
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UIActionSheetDelegate 代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        //打开照相机
        [self takePhoto];
    }
    else if (buttonIndex == 1) {
        
        //从相册中选择
        [self localPhoto];
    }
    else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

//打开照相机
- (void)takePhoto {
    
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else {
        
        [OHCommon showWeakTips:@"该设备无摄像头" View:self.view];
    }
}

//打开本地相册
- (void)localPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //调整图片方向
    UIImage *avaterImage = [OHCommon fixOrientation:image];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer uploadImageWithWithUrl:@"uploadPhoto" andDic:@{@"sessionId":kSessionId} Image:avaterImage completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //刷新个人信息页数据
        [self getUserInfoRequestWithSessionId:kSessionId];
        
        //更新本地AvaterUrl
        [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"response"] objectForKey:@"imgPath"] forKey:@"AvaterUrl"];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
