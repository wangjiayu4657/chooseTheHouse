//
//  Singleton.h
//  ClockClassroom
//
//  Created by lujun on 15/10/14.
//  Copyright © 2015年 EjuChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

/**
 *  区别新浪微博到底是登录还是分享
 *  “gotoUnionLogin”表示去登录
 *  “gotoShare”表示去分享
 *  “gotoBind”表示去绑定
 */
@property (nonatomic, copy) NSString *sinaType;

/**
 *  区别微信到底是登录还是绑定
 *  “gotoLogin”表示去登录
 *  “gotoBind”表示去绑定
 */
@property (nonatomic, copy) NSString *wechatType;

/**sectionHeaderViewHeight*/
@property (assign , nonatomic) CGFloat sectionHeaderViewHeight;

/**HeaderViewHeight*/
@property (assign , nonatomic) CGFloat headerViewHeight;

+ (instancetype)shareSingleton;

@end
