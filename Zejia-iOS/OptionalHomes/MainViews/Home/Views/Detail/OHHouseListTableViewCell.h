//
//  OHHouseListTableViewCell.h
//  OptionalHome
//
//  Created by lujun on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHHouseListModel.h"

@interface OHHouseListTableViewCell : UITableViewCell

- (void)OHHouseListTableViewCellConfigWithWithModel:(OHHouseListModel *)model Site:(NSString *)site IndexPath:(NSIndexPath *)indexpath;

@end
