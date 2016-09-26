//
//  OHCollectionReusableHeaderView.m
//  OptionalHome
//
//  Created by fangjs on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHCollectionReusableHeaderView.h"


@interface OHCollectionReusableHeaderView ()



@end

@implementation OHCollectionReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.x = collectionViewCellMargin;
        self.imageView.height = self.height / 2;
        self.imageView.width = self.imageView.height;
        self.imageView.y = self.height / 2 - self.imageView.height / 2;
        self.imageView.image = [UIImage imageNamed:@"cellFollowClickIcon"];
        [self addSubview:self.imageView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.height = 21;
        self.contentLabel.x = CGRectGetMaxX(self.imageView.frame) + collectionViewCellMargin;
        self.contentLabel.width = self.width - self.contentLabel.x;
        self.contentLabel.y = self.height / 2 - self.contentLabel.height / 2;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.textColor = [UIColor blackColor];
        [self addSubview:self.contentLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setContentLabel:(UILabel *)contentLabel {
    _contentLabel = contentLabel;
}

-(void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    _contentLabel.text = contentStr;
}

@end
