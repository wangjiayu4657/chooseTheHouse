//
//  OHFrequentLocationController.h
//  OptionalHome
//
//  Created by Dr_liu on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"

@interface OHFrequentLocationController : OHBaseViewController

@property (strong, nonatomic) IBOutlet UIView *workView;
@property (strong, nonatomic) IBOutlet UIView *liveView;

@property (strong, nonatomic) IBOutlet UILabel *workLabel;
@property (strong, nonatomic) IBOutlet UILabel *liveLabel;

@property (strong, nonatomic) IBOutlet UILabel *describeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *livePlaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic, copy) NSString *workString;
@property (nonatomic, copy) NSString *lifeString;

@property (nonatomic, strong) NSMutableArray *frequentArray;  // 装数据

- (IBAction)checkButton:(UIButton *)sender;

@end
