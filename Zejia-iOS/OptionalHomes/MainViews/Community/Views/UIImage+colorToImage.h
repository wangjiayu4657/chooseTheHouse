//
//  UIImage+colorToImage.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (colorToImage)

/**
 *   颜色生成图片方法(有状态值)
 *
 *  @param color 需要转化的颜色值
 *
 *  @return UIImage
 */
+(UIImage *)imageWithColor:(UIColor *)color;

/**
 *  颜色生成图片方法
 *
 *  @param color 需要转化的颜色值
 *  @param size  比例
 *
 *  @return UIImage
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
