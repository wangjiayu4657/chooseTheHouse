//
//  OHLoginModel.h
//  OptionalHome
//
//  Created by lujun on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHLoginModel : NSObject

@property (nonatomic, copy) NSString *sessionId;        //用户sessionid
@property (nonatomic, copy) NSString *nickname;         //用户昵称
@property (nonatomic, copy) NSString *photoUrl;         //头像url
@property (nonatomic, copy) NSString *inHome;           //是否进入列表首页：1进去首页，0进入标签选择

@end
