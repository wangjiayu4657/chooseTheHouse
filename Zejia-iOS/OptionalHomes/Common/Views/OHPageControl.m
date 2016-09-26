//
//  OHPageControl.m
//  OptionalHome
//
//  Created by haili on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHPageControl.h"

@implementation OHPageControl
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 10;
        size.width = 10;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
        subview.layer.cornerRadius = 5;
        if (subviewIndex == page) {
            [subview setBackgroundColor:self.currentPageIndicatorTintColor];
        } else {
            [subview setBackgroundColor:self.pageIndicatorTintColor];
        }
    }
}
@end
