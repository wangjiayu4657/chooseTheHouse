//
//  OHDataTool.h
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHDataTool : NSObject


extern NSString *const kDataSourceSectionKey;
extern NSString *const kDataSourceCellTextKey;
extern NSString *const kDataSourceCellPictureKey;

+ (NSMutableArray *)dataSource;
+ (NSMutableArray *)allTags;

@end
