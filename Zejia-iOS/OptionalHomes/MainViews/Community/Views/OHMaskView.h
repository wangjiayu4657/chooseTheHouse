//
//  OHMaskView.h
//  OptionalHome
//
//  Created by Dr_liu on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 设置MaskView的代理  现在改用block回调 _isSave */
@protocol OHMaskViewDelegate <NSObject>


- (void)backData:(NSMutableArray*)saveArray;

@end

@interface OHMaskView : UIView

// 上层传过来的标签名
@property (nonatomic, copy) NSString *nameString;

// 接收上一层传过来的数据
@property (nonatomic, copy) NSMutableArray *dataArray;

// 接收上层点击的button的tag，设置scrollview偏移量
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, weak) id<OHMaskViewDelegate>delegate;

@end
