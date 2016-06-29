//
//  SZGesturePasswordView.h
//  SZGesturePasswordView
//
//  Created by 陈圣治 on 16/6/28.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZGesturePasswordView;


typedef NS_ENUM(NSInteger, SZGesturePasswordViewContentMode) {
    SZGesturePasswordViewContentModeCenter,
    SZGesturePasswordViewContentModeTop,
    SZGesturePasswordViewContentModeBottom,
    SZGesturePasswordViewContentModeLeft,
    SZGesturePasswordViewContentModeRight,
    SZGesturePasswordViewContentModeTopLeft,
    SZGesturePasswordViewContentModeTopRight,
    SZGesturePasswordViewContentModeBottomLeft,
    SZGesturePasswordViewContentModeBottomRight,
};


/**
 *  slide end block
 *
 *  @param gpView SZGesturePasswordView
 *  @param indexs index array
 *
 *  @return YES: will show error image and error line if not secure;
 */
typedef BOOL(^SZGesturePasswordViewIsErrorBlock)(SZGesturePasswordView *gpView, NSArray *indexs);



@protocol SZGesturePasswordViewDelegate <NSObject>

/**
 *  slide end
 *
 *  @param gpView SZGesturePasswordView
 *  @param indexs index array
 *
 *  @return YES: will show error image and error line if not secure;
 */
- (BOOL)gesturePasswordView:(SZGesturePasswordView *)gpView isErrorWithIndexs:(NSArray *)indexs;

@end


IB_DESIGNABLE
@interface SZGesturePasswordView : UIView

//default 3
@property (nonatomic) IBInspectable NSUInteger level;

@property (nonatomic, strong) IBInspectable UIImage *normalImage;

@property (nonatomic, strong) IBInspectable UIImage *selectedImage;

@property (nonatomic, strong) IBInspectable UIImage *errorImage;

//default 40
@property (nonatomic) IBInspectable CGFloat dotViewsPadding;

//default {8, 8, 8, 8}, used to calculate it's intrinsic content size
@property (nonatomic) IBInspectable UIEdgeInsets edgeInset;

//default [UIColor orangeColor]
@property (nonatomic, strong) IBInspectable UIColor *slideLineColor;
//default [UIColor redColor]
@property (nonatomic, strong) IBInspectable UIColor *errorLineColor;

//default 4pt
@property (nonatomic) IBInspectable CGFloat lineWidth;

//default 1s
@property (nonatomic) IBInspectable NSTimeInterval lineHoldDurationAfterSlideEnd;

//default NO; if YES, it will not show slide path
@property (nonatomic) IBInspectable BOOL isSecure;

//default NO
@property (nonatomic) IBInspectable BOOL canDuplicateSelect;

@property (nonatomic, copy) SZGesturePasswordViewIsErrorBlock isErrorBlock;

@property (nonatomic, weak) id<SZGesturePasswordViewDelegate>delegate;

/**
 *  This method will be invoke in -willMoveToWindow:, so you don't need manualy invoke it when you first create the view.
 */
- (void)reload;

@end
