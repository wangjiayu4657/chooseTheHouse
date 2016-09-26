//
//  OHTextField.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/5.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHTextField.h"
@interface OHTextField ()
@end

@implementation OHTextField

- (UITextField *)initWithFrame:(CGRect)frame
                  placeHolder:(NSString *)placeHolder
                          tag:(NSInteger)tag
                     delegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        OHTextField *_textField = [[OHTextField alloc] initWithFrame:frame];
        _textField.backgroundColor = OHColor(255, 255, 255, 1);
        _textField.layer.cornerRadius = 4;
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = OHColor(238, 238, 238, 1).CGColor;
        _textField.delegate = delegate;
        _textField.tag = tag;
        _textField.placeholder = placeHolder;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        _textField.textColor = OHColor(40, 35, 35, 1);
        // 输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
        return _textField;
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = placeHolder;
    }
}

@end
