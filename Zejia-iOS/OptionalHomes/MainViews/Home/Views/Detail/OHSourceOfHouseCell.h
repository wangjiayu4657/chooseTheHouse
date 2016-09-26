//
//  OHSourceOfHouseCell.h
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OHDetailCellModel;

static NSString * const sourceOfHouse = @"sourceOfHouse";

@interface OHSourceOfHouseCell : UITableViewCell

/**数据*/
@property (strong , nonatomic)  OHDetailCellModel *model;

//
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@end
