//
//  OHUserInfoTableViewCell.h
//  OptionalHome
//
//  Created by lujun on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHUserInfoModel.h"

@interface OHUserInfoTableViewCell : UITableViewCell

- (void)OHUserInfoTableViewCellConfigWithUserInfo:(OHUserInfoModel *)userInfoModel IndexPath:(NSIndexPath *)indexPath;

@end
