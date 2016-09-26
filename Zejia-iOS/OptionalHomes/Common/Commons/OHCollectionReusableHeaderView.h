//
//  OHCollectionReusableHeaderView.h
//  OptionalHome
//
//  Created by fangjs on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * const collectionHeader = @"collectionHeader";

@interface OHCollectionReusableHeaderView : UICollectionReusableView

/**UIImageView*/
@property (strong , nonatomic) UIImageView *imageView;
/**UILabel*/
@property (strong , nonatomic) UILabel *contentLabel;

/**标题内容*/
@property (strong , nonatomic)  NSString *contentStr;

@end
