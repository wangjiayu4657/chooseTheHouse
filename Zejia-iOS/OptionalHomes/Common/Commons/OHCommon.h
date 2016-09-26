//
//  OHCommon.h
//  OptionalHome
//
//  Created by haili on 16/7/19.
//  Copyright © 2016年 haili. All rights reserved.
//  公共方法

#import <Foundation/Foundation.h>

@interface OHCommon : NSObject

/**
 *  NSUserDefaults 存值
 *
 *  @param obj 表示存入的值
 *
 *  @param key 表示存入时的key
 *
 *  @return 返回去掉空格后的字符串
 */
+ (void)setDefaultsObject:(NSString *)obj forKey:(NSString *)key;

/**
 *  NSUserDefaults 取值
 *
 *  @param key 表示传入的key
 *
 *  @return 返回取到的
 */
+ (id)getDefaultsObjectForkey:(NSString *)key;

/**
 *  去掉字符串中的空格
 *
 *  @param str 表示传入的字符串
 *
 *  @return 返回去掉空格后的字符串
 */
+ (NSString *)removeWhiteSpace:(NSString *)str;


/**
 *  判断字符串是否为空或nil
 *
 *  @param str 表示传入的字符串
 *
 *  @return 返回YES，表示该字符串是空或是nil；返回NO，表示该字符串不为空或不为nil。
 */
+ (BOOL)isEmptyOrNull:(NSString *)str;
/**
 *  手机号码格式验证
 *
 *  @param mobile 表示手机号
 *
 *  @return 返回YES，表示该手机号格式正确；返回NO，表示该手机号格式错误。
 */
+ (BOOL)validateMobile:(NSString *)mobile;


/**
 *  获取系统当前时间，并设置时间格式
 *
 *  @param dateformat 表示日期的格式，例如：@"yyyy-MM-dd"
 *
 *  @return 返回对应格式的当前日期
 */
+ (NSString *)getSystemDate:(NSString *)dateformat;


/**
 *  将一个字符串转换为日期类型
 *
 *  @param inputDate 表示字符串类型的日期，例如：@"20160215"
 *  @param format    表示日期的格式，例如：@"yyyy-MM-dd"
 *
 *  @return 返回对应格式的日期
 */
+ (NSDate *)convertStrToDate:(NSString *)inputDate format:(NSString *)format;


/**
 *  将一个日期类型转换为字符串
 *
 *  @param date   表示日期，例如：@"2016-02-15"
 *  @param format 表示字符串格式，例如：@"yyyyMMdd"
 *
 *  @return 返回对应格式的字符串
 */
+ (NSString *)convertDateToStr:(NSDate *)date format:(NSString *)format;


/**
 *  MD5加密
 *
 *  @param input 表示需要加密的字符串
 *
 *  @return 返回MD5加密后的字符串
 */
+ (NSString *)md5HexDigest:(NSString*)input;
/**
 *  解析url参数
 *
 *  @param query    表示url的参数
 *  @param encoding 表示编码格式，例如：NSUTF8StringEncoding
 *
 *  @return 返回字典格式的所有url参数
 */
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;
/**
 *  获取当前时间的时间戳
 *
 *  @return 返回字符串类型的当前时间的时间戳
 */
+ (NSString *)getTimeStamp;


/**
 *  将时间戳转换成日期时间
 *
 *  @param stamp 表示时间戳
 *
 *  @return 返回字符串类型的日期时间
 */
+ (NSString *)TimeStampChangeToDate:(NSTimeInterval)stamp;
+ (NSString *)TimeStampChangeToDateforMM:(NSTimeInterval)stamp;//精确到分钟
/**
 *  Json字符串转成字典
 *
 *  @param jsonString 表示Json字符串
 *
 *  @return 返回字典类型的数据
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  动态计算标签label的宽度
 *
 *  @param content 内容
 *  @param font    字体
 *
 *  @return 宽度
 */
+ (CGFloat) getLabelWidthWith:(NSString *)content and:(CGFloat)font;
/**
 *  固定宽度计算label的高度
 *
 *  @param content 内容
 *  @param width   宽度
 *  @param font    字体
 *
 *  @return 高度
 */
+ (CGFloat) getLabelHeightWith:(NSString *)content andWidth:(CGFloat)width andFont:(CGFloat)font;
/**
 *  获取label的行数
 *
 *  @param label label
 *
 *  @return 行数
 */
+ (NSNumber *)numberOfLabel:(UILabel *)label;
/**
 *  裁剪图片
 *
 *  @param image 原图
 *  @param scale 比例
 *
 *  @return 返回的新图
 */
+ (UIImage *)cutImage:(UIImage*)image andScale:(CGFloat)scale;

/**
 *  调整图片方向
 *
 *  @param image 原图
 *
 *  @return 返回的新图
 */
+ (UIImage *)fixOrientation:(UIImage *)srcImg;
/**
 *  显示弱提示框
 *
 *  @param tipStr 表示提示框的父视图
 *  @param view   表示提示框的提示文字
 */
+ (void)showWeakTips:(NSString *)tipStr View:(UIView *)view;

@end
