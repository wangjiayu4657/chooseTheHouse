//
//  OHSideHeaderView.h
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHIndexPathButton.h"
#import "OHRightImageButton.h"


static NSString * const kHeaderViewCellIdentifier = @"kHeaderViewCellIdentifier";

@class OHSideHeaderView;
@protocol OHSideHeaderViewDelegate <NSObject>

@required
- (void) OHSideHeaderViewMoreButtonClick:(UIButton *) sender;

@end

extern const float OHSideHeaderViewHeigt;

@interface OHSideHeaderView : UICollectionReusableView

@property (strong , nonatomic) NSString *title;
@property (nonatomic, strong) UIButton       *titleButton;
@property (nonatomic, strong) OHRightImageButton      *moreButton;
@property (nonatomic, weak  ) id<OHSideHeaderViewDelegate> delegate;

- (void)moreBtnClicked:(id)sender;

@end
