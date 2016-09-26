//
//  OHPeripheryAnnotation.h
//  OptionalHome
//
//  Created by 施澍 on 16/8/11.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
@interface OHPeripheryAnnotation : NSObject<BMKAnnotation>
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
