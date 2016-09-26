//
//  UIImage+OHImage.m
//  OptionalHome
//
//  Created by haili on 16/7/20.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "UIImage+OHImage.h"

@implementation UIImage (OHImage)
//设置UIImage的渲染模式
+(instancetype)orignalImageWithName:(NSString *)imageName{
    
    UIImage *image=[UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

//根据颜色返回纯色图片
+ (instancetype)imageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

- (UIImage *) circleImage {
    //NO : 透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //获取上下文
    CGContextRef contex = UIGraphicsGetCurrentContext();
    //设置原形区域
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(contex, rect);
    //裁剪
    CGContextClip(contex);
    //将裁剪后的图片画上去
    [self drawInRect:rect];
    //获取处理完的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


@end
