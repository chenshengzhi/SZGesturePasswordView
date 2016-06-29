//
//  DataSourceModel.m
//  SZGesturePasswordView
//
//  Created by 陈圣治 on 16/6/29.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "DataSourceModel.h"

@implementation DataSourceModel

+ (instancetype)modelWithTitle:(NSString *)title config:(void(^)(SZGesturePasswordView *gpView))config {
    DataSourceModel *model = [[DataSourceModel alloc] init];
    model.title = title;
    model.config = config;
    return model;
}

@end
