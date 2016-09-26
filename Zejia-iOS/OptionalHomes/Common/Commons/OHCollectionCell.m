//
//  OHCollectionCell.m
//  OptionalHome
//
//  Created by fangjs on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHCollectionCell.h"


@interface OHCollectionCell ()



@end

@implementation OHCollectionCell



- (void)awakeFromNib {
//    self.contentLabel.font = [OHFont systemFontOfSize:16.0*kAdaptationCoefficient];
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    self.contentLabel.text = content;
}



@end
