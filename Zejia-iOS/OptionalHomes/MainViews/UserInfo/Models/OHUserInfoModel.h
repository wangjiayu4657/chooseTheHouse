//
//  OHUserInfoModel.h
//  OptionalHome
//
//  Created by lujun on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHUserInfoModel : NSObject

@property (nonatomic, copy) NSString *nickname;         //用户昵称
@property (nonatomic, copy) NSString *photoUrl;         //头像url
@property (nonatomic, copy) NSString *mobile;           //绑定手机号
@property (nonatomic, copy) NSString *weixin;           //绑定微信号
@property (nonatomic, copy) NSString *qq;               //绑定QQ号
@property (nonatomic, copy) NSString *weibo;            //绑定微博号

@end
