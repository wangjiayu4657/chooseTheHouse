//
//  OHCommunitySubTagModel.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/7.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHCommunitySubTagModel : NSObject

@property (nonatomic, copy) NSString *children;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSNumber *ID;

@property (nonatomic, strong) NSNumber *isCheck;

@property (nonatomic, strong) NSNumber *order;

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, strong) NSNumber *type;


@end
