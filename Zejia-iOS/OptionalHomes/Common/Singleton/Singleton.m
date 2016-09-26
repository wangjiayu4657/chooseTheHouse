//
//  Singleton.m
//  ClockClassroom
//
//  Created by lujun on 15/10/14.
//  Copyright © 2015年 EjuChina. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

static Singleton * shareSingleton = nil;

+ (instancetype)shareSingleton
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        
        shareSingleton = [[self alloc] init] ;
        shareSingleton.sectionHeaderViewHeight = 0;
//        shareSingleton.headerViewHeight = 447;
    }) ;
    return shareSingleton ;
}

@end
