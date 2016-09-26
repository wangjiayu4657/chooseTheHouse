//
//  OHDataTool.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHDataTool.h"

@implementation OHDataTool

NSString *const kDataSourceSectionKey     = @"Items";
NSString *const kDataSourceCellTextKey    = @"Item_Title";
NSString *const kDataSourceCellPictureKey = @"Picture";

/**
 *  lazy load _dataSource
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)dataSource {
    static NSMutableArray * dataSource = nil;
    static dispatch_once_t dataSourceOnceToken;
    dispatch_once(&dataSourceOnceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        NSError *error;
        if (data) {
            dataSource = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
    });
    return dataSource;
}

/**
 *  lazy load _allTags
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)allTags {
    static NSMutableArray * allTags = nil;
    static dispatch_once_t allTagsOnceToken;
    dispatch_once(&allTagsOnceToken, ^{
        allTags = [NSMutableArray array];
        [[[self class] dataSource] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *items = [NSArray arrayWithArray:[obj objectForKey:kDataSourceSectionKey]];
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [allTags addObject:[obj objectForKey:kDataSourceCellTextKey]];
            }];
        }];
    });
    return allTags;
}




@end
