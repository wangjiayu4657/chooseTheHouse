//
//  UIImage+colorToImage.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "UIImage+colorToImage.h"

@implementation UIImage (colorToImage)

#pragma mark - 颜色生成图片方法
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(0.5f, 0.5f)];
}


+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
