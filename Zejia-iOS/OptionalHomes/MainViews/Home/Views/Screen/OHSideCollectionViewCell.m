//
//  OHSideCollectionViewCell.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSideCollectionViewCell.h"
#import "OHIndexPathButton.h"


@interface OHSideCollectionViewCell ()

@property (strong , nonatomic) Singleton *single;

@property (strong , nonatomic) NSMutableArray *filterCheckArray;

@end

@implementation OHSideCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
    [self setup];
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 4.0 * kAdaptationCoefficient;
    self.layer.masksToBounds = YES;
    self.button = [OHIndexPathButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.bounds;
    [self.contentView addSubview:self.button];
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    [self.button setTitle:contentString forState:UIControlStateNormal];
}


@end

