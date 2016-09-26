//
//  OHTextField.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/5.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, copy) NSString *placeHolder;

- (instancetype)initWithFrame:(CGRect)frame
                  placeHolder:(NSString *)placeHolder
                          tag:(NSInteger)tag
                     delegate:(id)delegate;

@end
