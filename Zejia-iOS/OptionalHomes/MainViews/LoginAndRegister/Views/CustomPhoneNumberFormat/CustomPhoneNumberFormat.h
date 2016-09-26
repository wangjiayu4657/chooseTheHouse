//
//  CustomPhoneNumberFormat.h
//  CustomPhoneNumberFormat
//
//  Created by wuxinyi on 1/12/15.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomPhoneNumberBlock)(NSString*);

@interface CustomPhoneNumberFormat : UITextField

@property(nonatomic,copy)CustomPhoneNumberBlock block;
@end
