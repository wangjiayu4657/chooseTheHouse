//
//  OHLiveCollectionCell.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHLiveCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *img1View;    // 上面图片
@property(nonatomic, strong) UILabel     *txtLabel;    // 描述信息
@property(nonatomic, strong) UILabel     *titlLabel;   // 标题
@property(nonatomic, strong) UIImageView *img2View;    // 下面图片
@property(nonatomic, strong) UIImageView *stausImage;  //选中状态的图片
@property (nonatomic, copy)  NSString    *desc;        //描述文字
@property (nonatomic, assign) BOOL       isCheck;

// 添加自定义控件
- (void)addSubView;

@end
