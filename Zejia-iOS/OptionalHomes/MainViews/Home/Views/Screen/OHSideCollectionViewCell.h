//
//  OHSideCollectionViewCell.h
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OHIndexPathButton;

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface OHSideCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) OHIndexPathButton *button;

/**内容*/
@property (strong , nonatomic)  NSString *contentString;

@end
