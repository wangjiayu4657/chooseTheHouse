//
//  OHSideFooterView.h
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kFooterViewCellIdentifier = @"kFooterViewCellIdentifier";

@interface OHSideFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
