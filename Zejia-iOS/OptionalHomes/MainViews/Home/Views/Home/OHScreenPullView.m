//
//  OHScreenPullView.m
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//
#define TABLEROWHEIGHT 48*kAdaptationCoefficient
#import "OHScreenPullView.h"
#import "OHScreenPullTableViewCell.h"
#import "OHScreenModel.h"
@implementation OHScreenPullView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OHScreenW, 0)];
        self.contentView.backgroundColor = OHColor(255, 255, 255, 1);
        [self addSubview:self.contentView];
        self.contentView.userInteractionEnabled = YES;
        NSInteger number = _selectArr.count>8?8:_selectArr.count;
        self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, TABLEROWHEIGHT *number) style:UITableViewStylePlain];
        self.selectTableView.delegate = self;
        self.selectTableView.dataSource = self;
        [self.contentView addSubview:self.selectTableView];
        
    }
    return self;
}
-(void)initWithselecttArr{
    
    [self.selectTableView reloadData];
    NSInteger currentRow = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (OHScreenModel *model in self.selectArr) {
        [arr addObject:model.Item_Title];
    }
    currentRow = [arr indexOfObject:self.selectName];
    [self.selectTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

-(void)setView{
    
    [UIView animateWithDuration:0.2 animations:^{
          NSInteger number = _selectArr.count>8?8:_selectArr.count;
        self.contentView.frame= CGRectMake(0, 0, OHScreenW,TABLEROWHEIGHT *number);
        self.selectTableView.frame = self.contentView.frame;
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, TABLEROWHEIGHT *number, OHScreenW, OHScreenH-TABLEROWHEIGHT *number)];
        blackView.userInteractionEnabled = YES;
        [self addSubview:blackView];
        UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endView)];
        [blackView addGestureRecognizer:endTap];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)endView{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame=CGRectMake(0, 0, OHScreenW, 0);
        self.selectTableView.frame = self.contentView.frame;
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat angle;
            angle = -M_PI*2;
            _selectBtn.buttomImage.transform = CGAffineTransformMakeRotation(angle);
        } completion:^(BOOL finished) {
            
        }];
       
        _selectBtn.isSelected = NO;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    OHScreenPullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil){
        
        cell = [[OHScreenPullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellWith:_selectArr[indexPath.row] andSelectStr:_selectName];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLEROWHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endView];
    OHScreenModel *model = [_selectArr objectAtIndex:indexPath.row];
    _selectName = model.Item_Title;
    [self.selectTableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(selectTableRow:btnTag:selectStr:selectIndex:)]) {
        
        [self.delegate selectTableRow:self btnTag:_selectBtn.tag selectStr:_selectName selectIndex:model.Item_Id];
    }
}

@end
