//
//  CustomPhoneNumberFormat.m
//  CustomPhoneNumberFormat
//
//  Created by wuxinyi on 1/12/15.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "CustomPhoneNumberFormat.h"
@interface CustomPhoneNumberFormat () <UITextFieldDelegate>
{
    NSString *previousTextFieldContent; //在输入后，textfield之前的文本
    UITextRange *previousSelection;        //同理为之前的光标位置
}
@end
@implementation CustomPhoneNumberFormat

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self addTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

#pragma mark-控制事件触发：UIControlEventEditingChanged
- (void)reformatAsCardNumber:(UITextField *)textField
{
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start]; //当前光标的位置
    
    NSString *cardNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];//删除(通过遍历删除空格)或增加(对数字进行限制)
    if ([cardNumberWithoutSpaces length] > 11) {//大于限制位数时值不变
        
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        
        return;
    }
    
    NSString *cardNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition]; //添加时
    self.block(cardNumberWithSpaces);//添加一个block 将值传出去
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:targetCursorPosition];
    
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    NSString *selectedText = [textField textInRange:textField.selectedTextRange];
    return YES;
}

#pragma mark-对字符串进行删空格的操作
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if (isdigit(characterToAdd)) {
            
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

#pragma mark -string:通过删除操作的处理，是一段无空格的字符串、cursorPosition：光标的位置
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        if (((i > 0) && (i == 3)) ||((i > 0) && (i == 7))) {//控制插入空格的索引位置-此处是对银行卡的限制(i > 0) && ((i % 4) == 0)
            [stringWithAddedSpaces appendString:@" "];
            
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

#pragma mark ——对textfield的长按效果进行限制
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if (menuController) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return NO;
//}

@end
