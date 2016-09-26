//
//  OHLeftHeaderTableViewCell.h
//  OptionalHome
//
//  Created by haili on 16/7/28.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHLeftHeaderTableViewCell : UITableViewCell

/**
 *  设置cell的内容
 *
 *  @param headerUrl 头像的url
 *  @param name      名字
 */
-(void)setCellWith:(NSString *)headerUrl andName:(NSString *)name;
@end
