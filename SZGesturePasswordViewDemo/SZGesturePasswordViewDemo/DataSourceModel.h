//
//  DataSourceModel.h
//  SZGesturePasswordView
//
//  Created by 陈圣治 on 16/6/29.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZGesturePasswordView;

@interface DataSourceModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^config)(SZGesturePasswordView *gpView);

+ (instancetype)modelWithTitle:(NSString *)title config:(void(^)(SZGesturePasswordView *gpView))config;

@end
