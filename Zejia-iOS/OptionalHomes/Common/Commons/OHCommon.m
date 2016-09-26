//
//  OHCommon.m
//  OptionalHome
//
//  Created by haili on 16/7/19.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHCommon.h"
#import <CommonCrypto/CommonDigest.h>

@implementation OHCommon
// NSUserDefaults 存值

+ (void)setDefaultsObject:(NSString *)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// NSUserDefaults 取值
+ (id)getDefaultsObjectForkey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
//去掉字符串中的空格
+ (NSString *)removeWhiteSpace:(NSString *)str {
    
    NSString *string = nil;
    if (![str isEqualToString:@""]) {
        
        string = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        return string;
    }
    return string;
}
//判断字符串是否为nil 或者 null
+ (BOOL)isEmptyOrNull:(NSString *)str {
    
    if (!str || [str isEqual: [NSNull null]] || str == NULL) {
        
        return YES;
    } else {
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            
            return YES;
        }
        else {
            
            return NO;
        }
    }
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    
    //手机号以13， 15，17,18开头，八个 \d 数字字符
    NSString *mobileNum = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNum];
    if (([regextestmobile evaluateWithObject:mobile] == YES)) {
        
        return YES;
    }
    else {
        
        return NO;
    }
}
//获取系统当前时间，并设置时间格式
+ (NSString *)getSystemDate:(NSString *)dateformat {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = dateformat;
    NSString *dateString = [fmt stringFromDate:now];
    return dateString;
}

//将一个字符串转换为日期类型
+ (NSDate *)convertStrToDate:(NSString *)inputDate format:(NSString *)format {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setDateFormat:format];
    NSDate * date= [outputFormatter dateFromString:inputDate];
    return date;
}

//将一个日期类型转换为字符串
+ (NSString *)convertDateToStr:(NSDate *)date format:(NSString *)format {
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = format;
    NSString* dateString = [fmt stringFromDate:date];
    return dateString;
}

//MD5加密
+ (NSString *)md5HexDigest:(NSString*)input {
    
    const char * str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return [ret lowercaseString];
}

//解析url参数
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}
//获取当前时间的时间戳
+ (NSString *)getTimeStamp {
    
    NSDate *datenow = [NSDate date];   //当前时间
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timestamp;
}

//将时间戳转换成日期时间
+ (NSString *)TimeStampChangeToDate:(NSTimeInterval)stamp {
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [timeFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSString *dateStr = [timeFormatter stringFromDate:date];
    return dateStr;
}

//将时间戳转换成时间精确到分钟
+ (NSString *)TimeStampChangeToDateforMM:(NSTimeInterval)stamp {
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSString *dateStr = [timeFormatter stringFromDate:date];
    return dateStr;
}
//Json字符串转成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//动态计算标签label的宽度
+ (CGFloat) getLabelWidthWith:(NSString *)content and:(CGFloat)font{
    
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size.width+5;
}
//固定宽度计算label的高度
+ (CGFloat) getLabelHeightWith:(NSString *)content andWidth:(CGFloat)width andFont:(CGFloat)font{
    // 获取文本的宽度
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attributeDic = @{NSFontAttributeName: [OHFont systemFontOfSize:font], NSParagraphStyleAttributeName: paragraph};
    // label.text
    CGSize mySize =[content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:nil].size;
    float height= mySize.height + 1;
    return height;
}
//获取label的行数
+ (NSNumber *)numberOfLabel:(UILabel *)label{
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / label.font.lineHeight);
    NSLog(@"共 %td 行", [count integerValue]);
    return count;
}
//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image andScale:(CGFloat)scale
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < scale) {
        newSize.width = image.size.width;
        scale = 1.0/scale;
        newSize.height = image.size.width * scale;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * scale;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}
//调整图片方向
+ (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//显示弱提示框
+ (void)showWeakTips:(NSString *)tipStr View:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.alpha = 0.9;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tipStr;
    hud.label.font = [OHFont systemFontOfSize:15*kAdaptationCoefficient];
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:1.5];
}
@end
