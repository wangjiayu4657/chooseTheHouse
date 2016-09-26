//
//  AppDelegate.h
//  OptionalHome
//
//  Created by haili on 16/7/18.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHLeftSlideViewController.h"

@class OHGuideViewController;

//static NSString *appKey = @"appkey";
//static NSString *channel = @"Publish channel";
//static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    OHGuideViewController*  guideViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) OHLeftSlideViewController *LeftSlideVC;


@end

