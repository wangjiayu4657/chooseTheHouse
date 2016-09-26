//
//  AFServer.h
//  OptionalHome
//
//  Created by haili on 16/7/19.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"

@interface AFServer : AFHTTPSessionManager

+ (id)sharedClient;

+ (id)sharedUploadImageClient;

//网络请求
+ (void)requestDataWithUrl:(NSString *)url andDic:(NSDictionary *)parameters completion:(void (^)(NSDictionary *dic))completion failure:(void (^)(NSError *error))failure;

//图片上传
+ (void)uploadImageWithWithUrl:(NSString *)url andDic:(NSDictionary *)parameters Image:(UIImage *)image completion:(void (^)(NSDictionary *dic))completion failure:(void (^)(NSError *error))failure;

@end
