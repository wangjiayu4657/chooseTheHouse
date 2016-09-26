//
//  OHDetailViewController.h
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHBaseViewController.h"

@interface OHDetailViewController : OHBaseViewController

/**社区 ID*/
@property (strong , nonatomic) NSNumber *communityId;

@property (strong , nonatomic) void (^baseViewControllerCompleted)(NSString *state);

@end
