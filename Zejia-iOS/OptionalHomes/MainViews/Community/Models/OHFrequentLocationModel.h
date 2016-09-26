//
//  OHFrequentLocationModel.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/8.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHFrequentLocationModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *addrName;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *type;

@end
