//
//  OHCollectionCell.h
//  OptionalHome
//
//  Created by fangjs on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const collectionCellID = @"collectionCellID";

@interface OHCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**<#strong#>*/
@property (strong , nonatomic) NSString *content;


@end
