//
//  AFServer.m
//  OptionalHome
//
//  Created by haili on 16/7/19.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "AFServer.h"
@implementation AFServer
+ (id)sharedClient
{
    static AFServer *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFServer alloc] initWithBaseURL:[NSURL URLWithString:BasicURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = 15.0;     //超时时间15秒
        
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    
    return _sharedClient;
}

+ (id)sharedUploadImageClient {

    static AFServer *sharedUploadImageClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUploadImageClient = [[AFServer alloc] initWithBaseURL:[NSURL URLWithString:BasicURL]];
        sharedUploadImageClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        sharedUploadImageClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        sharedUploadImageClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedUploadImageClient.requestSerializer.timeoutInterval = 15.0;     //超时时间15秒
        
        [sharedUploadImageClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    
    return sharedUploadImageClient;
}

+ (void)requestDataWithUrl:(NSString *)url andDic:(NSDictionary *)parameters completion:(void (^)(NSDictionary *dic))completion failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (parameters != nil) {
        [resultDic setObject:parameters forKey:@"data"];
    }
    else {
        [resultDic setObject:@"" forKey:@"data"];
    }
    NSDictionary *dic = @{@"version":INTERFACE_VER,@"os":INTERFACE_OS,@"channel":INTERFACE_CHANNEL,@"deviceToken":INTERFACE_DEVICETOKEN,@"plat":INTERFACE_PLAT,@"language":INTERFACE_LANGUAGE};
    [resultDic setObject:dic forKey:@"common"];
    
    [[AFServer sharedClient] POST:url parameters:resultDic progress:^(NSProgress * _Nonnull uploadProgress) {
                
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"url = %@",url);
        NSLog(@"parameters = %@",parameters);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if (completion)
        {
            completion(result);
        }
        NSLog(@"result = %@",result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
            NSLog(@"error = %@",error);
        }
    }];
}

//图片上传
+ (void)uploadImageWithWithUrl:(NSString *)url andDic:(NSDictionary *)parameters Image:(UIImage *)image completion:(void (^)(NSDictionary *dic))completion failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (parameters != nil) {
        [resultDic setObject:parameters forKey:@"data"];
    }
    else {
        [resultDic setObject:@"" forKey:@"data"];
    }
    NSDictionary *dic = @{@"version":INTERFACE_VER,@"os":INTERFACE_OS,@"channel":INTERFACE_CHANNEL,@"deviceToken":INTERFACE_DEVICETOKEN,@"plat":INTERFACE_PLAT,@"language":INTERFACE_LANGUAGE};
    [resultDic setObject:dic forKey:@"common"];
    
    //param参数
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //file参数
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    
    NSDictionary *parametersDic = @{@"file":data, @"param":jsonStr};
    
    [[AFServer sharedUploadImageClient] POST:url parameters:parametersDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"avater.png" mimeType:@"image/*"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"url = %@",url);
        NSLog(@"parametersDic = %@",parametersDic);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if (completion)
        {
            completion(result);
        }
        NSLog(@"result = %@",result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
            NSLog(@"error = %@",error);
        }
    }];
}

@end
