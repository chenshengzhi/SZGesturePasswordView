//
//  SZGesturePasswordView.m
//  SZGesturePasswordView
//
//  Created by 陈圣治 on 16/6/28.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "SZGesturePasswordView.h"

#pragma mark - SZGesturePasswordImageView -
@interface SZGesturePasswordImageView : UIImageView

@property (nonatomic) NSInteger index;

@end

@implementation SZGesturePasswordImageView

@end

#pragma mark - SZGesturePasswordView -
@interface SZGesturePasswordView ()

@property (nonatomic) BOOL isError;

@property (nonatomic, strong) NSArray<SZGesturePasswordImageView*> *dotViewArray;
@property (nonatomic, strong) NSMutableArray<SZGesturePasswordImageView*> *selectedDotViewArray;

@property (nonatomic, strong) UITouch *touch;
@property (nonatomic) CGPoint latestTouchPoint;

@end

@implementation SZGesturePasswordView

#pragma mark - init -
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _level = 3;
    _dotViewsPadding = 40;
    _edgeInset = UIEdgeInsetsMake(8, 8, 8, 8);
    _slideLineColor = [UIColor orangeColor];
    _errorLineColor = [UIColor redColor];
    _lineWidth = 4;
    _lineHoldDurationAfterSlideEnd = 1;
    _isSecure = NO;
    _canDuplicateSelect = NO;

    _selectedDotViewArray = [NSMutableArray array];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (_selectedDotViewArray.count > 0 && !_isSecure) {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetStrokeColorWithColor(context, (_isError ? _errorLineColor : _slideLineColor).CGColor);

        UIView *dotView = _selectedDotViewArray[0];
        CGContextMoveToPoint(context, dotView.center.x, dotView.center.y);
        for (int i = 1; i < _selectedDotViewArray.count; i++) {
            UIView *dotView = _selectedDotViewArray[i];
            CGContextAddLineToPoint(context, dotView.center.x, dotView.center.y);
        }
        if (_touch) {
            CGPoint pt = [_touch locationInView:self];
            CGContextAddLineToPoint(context, pt.x, pt.y);
        }
        CGContextStrokePath(context);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        if (_dotViewArray.count == 0) {
            [self reload];
        }
    }
}

- (void)sizeToFit {
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize intrinsicSize = [self gp_intrinsicContentSize];
    return CGSizeMake(MIN(intrinsicSize.width, size.width), MIN(intrinsicSize.height, size.height));
}

- (CGSize)intrinsicContentSize {
    return [self gp_intrinsicContentSize];
}

- (CGSize)gp_intrinsicContentSize {
    CGFloat intrinsicWidth = _normalImage.size.width * _level + _dotViewsPadding * (_level - 1) + _edgeInset.left + _edgeInset.top;
    CGFloat intrinsicHeight = _normalImage.size.height * _level + _dotViewsPadding * (_level - 1) + _edgeInset.top + _edgeInset.bottom;
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark -  外部方法 -
- (void)reload {
    [_dotViewArray enumerateObjectsUsingBlock:^(SZGesturePasswordImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _selectedDotViewArray = [NSMutableArray array];

    CGFloat startX = _edgeInset.left;
    CGFloat startY = _edgeInset.top;

    CGPoint latestPoint = CGPointMake(startX, startY);
    NSMutableArray *dots = [NSMutableArray array];
    for (int i = 0; i < _level; i++) {
        for (int j = 0; j < _level; j++) {
            SZGesturePasswordImageView *dotView = [[SZGesturePasswordImageView alloc] initWithImage:_normalImage];
            dotView.index = i*_level + j;
            dotView.frame = CGRectMake(latestPoint.x, latestPoint.y, _normalImage.size.width, _normalImage.size.height);
            [self addSubview:dotView];
            [dots addObject:dotView];

            latestPoint.x += _normalImage.size.width + _dotViewsPadding;
        }
        latestPoint.x = startX;
        latestPoint.y += _normalImage.size.height + _dotViewsPadding;
    }
    _dotViewArray = [dots copy];
}

- (void)reset {
    _isError = NO;
    _touch = nil;
    for (SZGesturePasswordImageView *dotView in _selectedDotViewArray) {
        dotView.image = _normalImage;
    }
    [_selectedDotViewArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)updateForError {
    if (_selectedDotViewArray.count > 0 && !_isSecure) {
        _isError = YES;
        for (SZGesturePasswordImageView *dotView in _selectedDotViewArray) {
            dotView.image = _errorImage;
        }
        [self setNeedsDisplay];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_lineHoldDurationAfterSlideEnd * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reset];
    });
}

#pragma mark - touch -
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_touch) {
        return self;
    } else {
        for (SZGesturePasswordImageView *dotView in _dotViewArray) {
            if (CGRectContainsPoint(dotView.frame, point)) {
                return self;
            }
        }
        return nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_touch) {
        _touch = [touches anyObject];
        [self touchBeginHandler];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self validateTouchs:touches]) {
        [self touchMoveHandler];
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self validateTouchs:touches]) {
        [self touchEndHandler];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self validateTouchs:touches]) {
        [self touchEndHandler];
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - util -
- (void)touchEndHandler {
    _touch = nil;
    [self setNeedsDisplay];
    if (_selectedDotViewArray.count > 0) {
        NSArray *indexs = [_selectedDotViewArray valueForKey:@"index"];
        if (_isErrorBlock) {
            if (_isErrorBlock(self, indexs)) {
                [self updateForError];
            }
        }

        if (_delegate && [_delegate respondsToSelector:@selector(gesturePasswordView:isErrorWithIndexs:)]) {
            if ([_delegate gesturePasswordView:self isErrorWithIndexs:indexs]) {
                [self updateForError];
            }
        }

        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_lineHoldDurationAfterSlideEnd * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf reset];
        });
    }
}

- (void)touchMoveHandler {
    [self setNeedsDisplay];

    CGPoint point = [_touch locationInView:self];
    CGVector vector = CGVectorMake(point.x - _latestTouchPoint.x, point.y - _latestTouchPoint.y);
    CGFloat denominator = MAX(fabs(vector.dx), fabs(vector.dy));
    CGFloat numerator = MIN(_normalImage.size.width, _normalImage.size.height) / 2;
    if (denominator > numerator) {
        CGFloat percent = numerator / denominator;
        CGFloat scale = percent;

        while (scale < 1) {
            [self handleTouchWithPoint:CGPointMake(_latestTouchPoint.x + vector.dx * scale, _latestTouchPoint.y + vector.dy * scale)];
            scale += percent;
        }
    }
    [self handleTouchWithPoint:point];

    _latestTouchPoint = point;
}

- (void)touchBeginHandler {
    [self setNeedsLayout];

    _latestTouchPoint = [_touch locationInView:self];
    [self handleTouchWithPoint:_latestTouchPoint];
}

- (void)handleTouchWithPoint:(CGPoint)point {
    SZGesturePasswordImageView *touchedDotView = [self imageViewAtPoint:point];

    if (touchedDotView) {
        if (_canDuplicateSelect) {
            if (![_selectedDotViewArray.lastObject isEqual:touchedDotView]) {
                [_selectedDotViewArray addObject:touchedDotView];
            }
        } else {
            if (![_selectedDotViewArray containsObject:touchedDotView]) {
                [_selectedDotViewArray addObject:touchedDotView];
            }
        }
        if (!_isSecure) {
            touchedDotView.image = _selectedImage;
        }
    }
}

- (SZGesturePasswordImageView *)imageViewAtPoint:(CGPoint)point {
    for (SZGesturePasswordImageView *dotView in _dotViewArray) {
        if (CGRectContainsPoint(dotView.frame, point)) {
            return dotView;
        }
    }
    return nil;
}

- (BOOL)validateTouchs:(NSSet *)touches {
    for (UITouch *t in touches) {
        if (_touch == t) {
            return YES;
        }
    }
    return NO;
}

@end
