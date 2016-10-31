//
//  VVPopMenuView.m
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/8.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import "VVPopMenuView.h"
#import "VVPopMenuButton.h"
#import "POP.h"

static CGFloat      const VVPopMenuViewPopMenuButtonAnimationSpace          = 0.05;     // 每个Item直接的间隔时间
static NSInteger    const VVPopMenuViewMenuButtonDefaultMaxRow              = 2;        // 最大多少行数据，默认是2
static NSInteger    const VVPopMenuViewMenuButtonDefaultMaxColumn           = 3;        // 最大多少行数据，默认是2
static CGFloat      const VVPopMenuViewMenuButtonHorizontalDefaultMargin    = 5;        // 按钮左右间距默认5
static CGFloat      const VVPopMenuViewMenuButtonVerticalDefaultMargin      = 5;        // 按钮竖直间距默认5

@interface VVPopMenuView ()

@property (nonatomic, assign) CGFloat menuButtonHorizontalMargin;   // 水平方向的间距
@property (nonatomic, assign) CGFloat menuButtonVerticalMargin;     // 竖直方向的间距

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) NSArray<VVPopMenuModel *> *popMenuModelArray;
@property (nonatomic, strong) NSMutableArray<VVPopMenuButton *> *popMenuButtonArray;

@property (nonatomic, strong) NSMutableArray<NSValue *> *finalPositionArray;
@property (nonatomic, strong) NSMutableArray<NSValue *> *originPositionArray;

@end

@implementation VVPopMenuView

#pragma mark - LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.menuButtonHorizontalMargin = VVPopMenuViewMenuButtonHorizontalDefaultMargin;
        self.menuButtonVerticalMargin   = VVPopMenuViewMenuButtonVerticalDefaultMargin;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static VVPopMenuView *sharedInstance;
    static dispatch_once_t VVPopMenuViewToken;
    dispatch_once(&VVPopMenuViewToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - DataSource
#pragma mark - Delegate

#pragma mark - Public Method

- (void)showWithPopMenuModelArray:(NSArray<VVPopMenuModel *> *)popMenuModelArray {
    self.popMenuModelArray = popMenuModelArray;
    self.frame = [UIScreen mainScreen].bounds;
    // 间距
    if ([self.dataSource respondsToSelector:@selector(popMenuButtonHorizontalMarginInPopMenuView:)]) {
        self.menuButtonHorizontalMargin = [self.dataSource popMenuButtonHorizontalMarginInPopMenuView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(popMenuButtonVerticalMarginInPopMenuView:)]) {
        self.menuButtonVerticalMargin = [self.dataSource popMenuButtonVerticalMarginInPopMenuView:self];
    }
    if (self.popMenuModelArray == nil) {
        if ([self.dataSource respondsToSelector:@selector(popMenuModelArrayInPopMenuView:)]) {
            self.popMenuModelArray = [self.dataSource popMenuModelArrayInPopMenuView:self];
        }
    }
    if ([self.delegate respondsToSelector:@selector(popMenuViewWillShow:)]) {
        [self.delegate popMenuViewWillShow:self];
    }
    [self resetBackgroundViewWithCurrentBackgroundType];
    [self resetTopView];
    [self resetOtherSubView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self startShowAnimation];
}

- (void)disMiss {
    if ([self.delegate respondsToSelector:@selector(popMenuViewWillDisMiss:selectItemAtIndex:)]) {
        [self.delegate popMenuViewWillDisMiss:self selectItemAtIndex:-1];
    }
    [self startDisMissAnimation];
}

#pragma mark - Event Method

- (void)showPopMenuButtonsAnimation {
    [self.popMenuButtonArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSInteger count = self.popMenuModelArray.count;
    double animationTotalDuration = ((count - 1) * VVPopMenuViewPopMenuButtonAnimationSpace) + VVPopMenuViewAnimationDefaultDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTotalDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(popMenuViewDidShow:)]) {
            [weakSelf.delegate popMenuViewDidShow:weakSelf];
        }
    });
    self.finalPositionArray = [self calculatePopMenuButtonsFinalPosition];
    self.originPositionArray = [self calculatePopMenuButtonsOriginPositionWithFinalPosition:self.finalPositionArray];
    [self.popMenuModelArray enumerateObjectsUsingBlock:^(VVPopMenuModel * _Nonnull popMenuModel, NSUInteger index, BOOL * _Nonnull stop) {
        VVPopMenuButton *popMenuButton = [VVPopMenuButton popMenuButtonWithPopMenuModel:popMenuModel];
        popMenuButton.userInteractionEnabled = NO;
        [weakSelf.popMenuButtonArray addObject:popMenuButton];
        [weakSelf.contentView addSubview:popMenuButton];
        popMenuButton.alpha = 0.0;
        popMenuButton.frame = [self.originPositionArray[index] CGRectValue];
        CFTimeInterval delay = index * VVPopMenuViewPopMenuButtonAnimationSpace + CACurrentMediaTime();
        [weakSelf addAnimationWithFromRect:[self.originPositionArray[index] CGRectValue] toRect:[self.finalPositionArray[index] CGRectValue] delay:delay animationView:popMenuButton isShow:YES completionBlock:^(BOOL flag) {
            popMenuButton.userInteractionEnabled = YES;
        }];
        [popMenuButton addTarget:self action:@selector(selectPopMenuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)disMissPopMenuButtonsAnimation {
    __weak typeof(self) weakSelf = self;
    if (self.popMenuModelArray == nil) {
        if ([self.dataSource respondsToSelector:@selector(popMenuModelArrayInPopMenuView:)]) {
            self.popMenuModelArray = [self.dataSource popMenuModelArrayInPopMenuView:self];
        }
    }
    NSInteger count = self.popMenuModelArray.count;
    double animationTotalDuration = ((count - 1) * VVPopMenuViewPopMenuButtonAnimationSpace) + VVPopMenuViewAnimationDefaultDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTotalDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(popMenuViewDidDisMiss:selectItemAtIndex:)]) {
            [weakSelf.delegate popMenuViewDidDisMiss:weakSelf selectItemAtIndex:-1];
        }
        weakSelf.dataSource = nil;
        weakSelf.delegate = nil;
    });
    [self.popMenuModelArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(VVPopMenuModel * _Nonnull popMenuModel, NSUInteger index, BOOL * _Nonnull stop) {
        VVPopMenuButton *popMenuButton = weakSelf.popMenuButtonArray[index];
        CFTimeInterval delay = (count - 1 - index) * VVPopMenuViewPopMenuButtonAnimationSpace + CACurrentMediaTime();
        [weakSelf addAnimationWithFromRect:[self.finalPositionArray[index] CGRectValue] toRect:[self.originPositionArray[index] CGRectValue] delay:delay animationView:popMenuButton isShow:NO completionBlock:^(BOOL flag) {
        }];
    }];
}

- (void)closeButtonAction {
    [self disMiss];
}

- (void)startShowAnimation {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:VVPopMenuViewAnimationDefaultDuration animations:^{
        weakSelf.backgroundView.alpha = 1.0;
        weakSelf.closeButton.alpha = 1.0;
        weakSelf.closeButton.transform = CGAffineTransformMakeRotation(M_PI_4);
        weakSelf.topView.alpha = 1.0;
    }];
    [self showPopMenuButtonsAnimation];
}

- (void)startDisMissAnimation {
    __weak typeof(self) weakSelf = self;
    [self disMissPopMenuButtonsAnimation];
    double delay = (self.popMenuModelArray.count * VVPopMenuViewPopMenuButtonAnimationSpace) + VVPopMenuViewAnimationDefaultDuration;
    [UIView animateWithDuration:VVPopMenuViewAnimationDefaultDuration animations:^{
        weakSelf.closeButton.transform = CGAffineTransformMakeRotation(0);
        weakSelf.closeButton.alpha = 0.0;
        weakSelf.topView.alpha = 0.0;
    }];
    [UIView animateKeyframesWithDuration:VVPopMenuViewAnimationDefaultDuration delay:delay options:0 animations:^{
        weakSelf.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.popMenuButtonArray enumerateObjectsUsingBlock:^(VVPopMenuButton * _Nonnull popMenuButton, NSUInteger idx, BOOL * _Nonnull stop) {
            [popMenuButton removeFromSuperview];
        }];
        [weakSelf.popMenuButtonArray removeAllObjects];
        weakSelf.menuButtonHorizontalMargin = VVPopMenuViewMenuButtonHorizontalDefaultMargin;
        weakSelf.menuButtonVerticalMargin   = VVPopMenuViewMenuButtonVerticalDefaultMargin;
    }];
}

- (void)selectPopMenuButtonAction:(VVPopMenuButton *)selectPopMenuButton {
    NSInteger selectIndex = -1;
    if ([self.popMenuButtonArray containsObject:selectPopMenuButton]) {
        selectIndex = [self.popMenuButtonArray indexOfObject:selectPopMenuButton];
    }
    if ([self.delegate respondsToSelector:@selector(popMenuViewWillDisMiss:selectItemAtIndex:)]) {
        [self.delegate popMenuViewWillDisMiss:self selectItemAtIndex:selectIndex];
    }
    __weak typeof(self) weakSelf = self;
    self.contentView.userInteractionEnabled = NO;
    [self.popMenuButtonArray enumerateObjectsUsingBlock:^(VVPopMenuButton * _Nonnull popMenuButton, NSUInteger index, BOOL * _Nonnull stop) {
        if (popMenuButton == selectPopMenuButton) {
            [popMenuButton selectdAnimation];
        } else {
            [popMenuButton cancelAnimation];
        }
    }];
    [UIView animateWithDuration:VVPopMenuViewAnimationDefaultDuration animations:^{
        weakSelf.closeButton.transform = CGAffineTransformMakeRotation(0);
        weakSelf.closeButton.alpha = 0.0;
        weakSelf.topView.alpha = 0.0;
    }];
    [UIView animateKeyframesWithDuration:VVPopMenuViewAnimationDefaultDuration delay:VVPopMenuViewAnimationDefaultDuration options:0 animations:^{
        weakSelf.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.contentView.userInteractionEnabled = YES;
        [weakSelf removeFromSuperview];
        [weakSelf.popMenuButtonArray enumerateObjectsUsingBlock:^(VVPopMenuButton * _Nonnull popMenuButton, NSUInteger idx, BOOL * _Nonnull stop) {
            [popMenuButton removeFromSuperview];
        }];
        [weakSelf.popMenuButtonArray removeAllObjects];
        if ([weakSelf.delegate respondsToSelector:@selector(popMenuViewDidDisMiss:selectItemAtIndex:)]) {
            [weakSelf.delegate popMenuViewDidDisMiss:weakSelf selectItemAtIndex:selectIndex];
        }
        weakSelf.menuButtonHorizontalMargin = VVPopMenuViewMenuButtonHorizontalDefaultMargin;
        weakSelf.menuButtonVerticalMargin   = VVPopMenuViewMenuButtonVerticalDefaultMargin;
        weakSelf.dataSource = nil;
        weakSelf.delegate = nil;
    }];
}

#pragma mark - Property Method

- (NSInteger)maxColumn {
    if ([self.dataSource respondsToSelector:@selector(popMenuMaxColumnInPopMenuView:)]) {
        return [self.dataSource popMenuMaxColumnInPopMenuView:self];
    }
    return VVPopMenuViewMenuButtonDefaultMaxColumn;
}

- (void)setPopMenuModelArray:(NSArray<VVPopMenuModel *> *)popMenuModelArray {
    NSInteger maxColumn = self.maxColumn;
    if (popMenuModelArray.count > maxColumn * VVPopMenuViewMenuButtonDefaultMaxRow) {
        _popMenuModelArray = [[NSMutableArray arrayWithArray:popMenuModelArray] subarrayWithRange:NSMakeRange(0, maxColumn * VVPopMenuViewMenuButtonDefaultMaxRow)];
    } else {
        _popMenuModelArray = popMenuModelArray;
    }
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.adjustsImageWhenHighlighted = NO;
        [_closeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:40.0];
        _closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _closeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _closeButton.contentEdgeInsets = UIEdgeInsetsZero;
        _closeButton.titleEdgeInsets = UIEdgeInsetsZero;
        _closeButton.imageEdgeInsets = UIEdgeInsetsZero;
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (NSMutableArray<VVPopMenuButton *> *)popMenuButtonArray {
    if (_popMenuButtonArray == nil) {
        _popMenuButtonArray = [NSMutableArray array];
    }
    return _popMenuButtonArray;
}

#pragma mark - Private Method

- (void)resetBackgroundViewWithCurrentBackgroundType {
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.backgroundView.alpha = 0.0;
    [self.backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger index, BOOL * _Nonnull stop) {
        [subview removeFromSuperview];
    }];
    [self.gradientLayer removeFromSuperlayer];
    switch (self.backgroundType) {
        case VVPopMenuViewBackgroundTypeDarkBlur: {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.frame = self.bounds;
            [self.backgroundView insertSubview:visualEffectView atIndex:0];
            break;
        }
        case VVPopMenuViewBackgroundTypeDarkTranslucent: {
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            break;
        }
        case VVPopMenuViewBackgroundTypeLightBlur: {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.frame = self.bounds;
            [self.backgroundView insertSubview:visualEffectView atIndex:0];
            break;
        }
        case VVPopMenuViewBackgroundTypeLightTranslucent: {
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            break;
        }
        case VVPopMenuViewBackgroundTypeGradient: {
            CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
            self.gradientLayer = gradientLayer;
            gradientLayer.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.1].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
            gradientLayer.startPoint = CGPointMake(0.5f, -0.5);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            gradientLayer.frame = self.bounds;
            [self.backgroundView.layer addSublayer:gradientLayer];
            break;
        }
    }
    [self insertSubview:self.backgroundView atIndex:0];
    [self insertSubview:self.contentView aboveSubview:self.backgroundView];
}

- (void)resetTopView {
    [self.topView removeFromSuperview];
    self.topView = nil;
    if (![self.dataSource respondsToSelector:@selector(topViewInPopMenuView:)]) { // 顶部没有View
        return;
    }
    self.topView = [self.dataSource topViewInPopMenuView:self];
    [self.contentView addSubview:self.topView];
    CGFloat topViewWidth = self.frame.size.width;
    CGFloat topViewHeight = 95.0;
    if ([self.dataSource respondsToSelector:@selector(topViewHeightInPopMenuView:)]) {
        topViewHeight = [self.dataSource topViewTopInPopMenuView:self];
    }
    CGFloat topViewX = 0.0;
    CGFloat topViewY = 44.0;
    if ([self.dataSource respondsToSelector:@selector(topViewTopInPopMenuView:)]) {
        topViewY = [self.dataSource topViewTopInPopMenuView:self];
    }
    self.topView.frame = CGRectMake(topViewX, topViewY, topViewWidth, topViewHeight);
    self.topView.alpha = 0.0;
}

/**
 *  主要是设置底部的条状view和关闭按钮
 */
- (void)resetOtherSubView {
    self.closeButton.alpha = 0.0;
    CGFloat closeButtonWidth = 0.0;
    CGFloat closeButtonHeiught = 0.0;
    CGFloat closeButtonCenterX = 0.0;
    CGFloat closeButtonCenterY = 0.0;
    UIImage *closeButtonImage = nil;
    if ([self.dataSource respondsToSelector:@selector(closeButtonImageNameInPopMenuView:)]) {
        [self.closeButton setTitle:@"" forState:UIControlStateNormal];
        closeButtonImage = [UIImage imageNamed:[self.dataSource closeButtonImageNameInPopMenuView:self]];
        [self.closeButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
        closeButtonWidth = closeButtonImage ? closeButtonImage.size.width : 30.0;
        closeButtonHeiught = closeButtonWidth;
    } else {
        [self.closeButton setTitle:@"+" forState:UIControlStateNormal];
        closeButtonWidth = 30.0;
        closeButtonHeiught = closeButtonWidth;
    }
    if ([self.dataSource respondsToSelector:@selector(closeButtonSizeInPopMenuView:)]) {
        CGSize closeButtonSize = [self.dataSource closeButtonSizeInPopMenuView:self];
        closeButtonWidth = closeButtonSize.width;
        closeButtonHeiught = closeButtonSize.height;
    }
    closeButtonCenterX = self.frame.size.width * 0.5;
    CGFloat bottomPadding = 0.0;
    if ([self.dataSource respondsToSelector:@selector(closeButtonBottomPaddingInPopMenuView:)]) {
        bottomPadding = [self.dataSource closeButtonBottomPaddingInPopMenuView:self];
    } else {
        bottomPadding = (44.0 - closeButtonHeiught) * 0.5; // tabbar的高度
    }
    closeButtonCenterY = self.frame.size.height - bottomPadding - closeButtonHeiught * 0.5;
    [self.contentView addSubview:self.closeButton];
    self.closeButton.bounds = CGRectMake(0.0, 0.0, closeButtonWidth, closeButtonHeiught);
    self.closeButton.center = CGPointMake(closeButtonCenterX, closeButtonCenterY);
}

- (CGFloat)popMenuButtonBottomPadding {
    if ([self.dataSource respondsToSelector:@selector(popMenuButtonBottomPaddingInPopMenuView:)]) {
        return [self.dataSource popMenuButtonBottomPaddingInPopMenuView:self];
    }
    CGFloat popMenuButtonBottomPadding = 80.0; // 3.5屏幕下默认是80.0
    popMenuButtonBottomPadding = popMenuButtonBottomPadding * ([UIScreen mainScreen].bounds.size.height / 480.0);
    return popMenuButtonBottomPadding;
}

- (void)addAnimationWithFromRect:(CGRect)fromRect
                          toRect:(CGRect)toRect
                           delay:(CFTimeInterval)delay
                   animationView:(UIView*)animationView
                          isShow:(BOOL)isShow
                 completionBlock:(void (^)(BOOL flag))completionBlock {
    CGFloat springBounciness = 10.0;
    CGFloat springSpeed = 10.0;
    switch (self.showAnimationType) {
        case VVPopMenuViewShowAnimationTypeSina: {
            // Center
            POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            springAnimation.removedOnCompletion = YES;
            springAnimation.beginTime = delay;
            springAnimation.springBounciness = springBounciness; // value between 0-20
            springAnimation.springSpeed = springSpeed; // value between 0-20
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toRect), CGRectGetMidY(toRect))];
            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromRect), CGRectGetMidY(fromRect))];
            // Alpha
            POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            basicAnimationAlpha.removedOnCompletion = YES;
            basicAnimationAlpha.duration = VVPopMenuViewAnimationDefaultDuration;
            basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            basicAnimationAlpha.beginTime = delay;
            basicAnimationAlpha.toValue = isShow ? @(1) : @(0);
            basicAnimationAlpha.fromValue = isShow ? @(0) : @(1);
            
            [animationView pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
            [animationView pop_addAnimation:springAnimation forKey:springAnimation.name];
            [springAnimation setCompletionBlock:^(POPAnimation *springAnimation, BOOL flag) {
                completionBlock? completionBlock(flag) : nil;
            }];
            break;
        }
        case VVPopMenuViewShowAnimationTypeBottomRadiate: {
            // Center
            POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            springAnimation.removedOnCompletion = YES;
            springAnimation.beginTime = delay;
            springAnimation.springBounciness = springBounciness; // value between 0-20
            springAnimation.springSpeed = springSpeed; // value between 0-20
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toRect), CGRectGetMidY(toRect))];
            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromRect), CGRectGetMidY(fromRect))];
            // Alpha
            POPSpringAnimation *basicAnimationAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
            basicAnimationAlpha.removedOnCompletion = YES;
            basicAnimationAlpha.beginTime = delay;
            basicAnimationAlpha.toValue = isShow ? @(1) : @(0);
            basicAnimationAlpha.fromValue = isShow ? @(0) : @(1);
            // ScaleXY
            POPSpringAnimation *basicAnimationScaleXY = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            basicAnimationScaleXY.removedOnCompletion = YES;
            basicAnimationScaleXY.beginTime = delay;
            basicAnimationScaleXY.fromValue = isShow ? [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)] : [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)] ;
            basicAnimationScaleXY.toValue = isShow ? [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)] : [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)] ;
            
            [animationView pop_addAnimation:basicAnimationScaleXY forKey:basicAnimationScaleXY.name];
            [animationView pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
            [animationView pop_addAnimation:springAnimation forKey:springAnimation.name];
            [springAnimation setCompletionBlock:^(POPAnimation *springAnimation, BOOL flag) {
                completionBlock? completionBlock(flag) : nil;
            }];
            break;
        }
    }
}

- (NSMutableArray<NSValue *> *)calculatePopMenuButtonsFinalPosition {
    NSInteger maxColumn = self.maxColumn;
    NSInteger totalCount = self.popMenuModelArray.count;
    NSInteger totalRow = (totalCount + maxColumn - 1) / maxColumn;
    NSMutableArray<NSValue *> *finalPositionArray  = [NSMutableArray arrayWithCapacity:totalCount];
    
    CGFloat selfHeight = self.frame.size.height;
    CGFloat finalPopMenuWidth = (self.frame.size.width - maxColumn * self.menuButtonHorizontalMargin) / maxColumn;
    CGFloat finalPopMenuHeight = finalPopMenuWidth;
    CGFloat finalPopMenuX = 0.0;
    CGFloat finalPopMenuY = 0.0;
    CGFloat totalHeight = totalRow * finalPopMenuHeight + (totalRow - 1) * self.menuButtonVerticalMargin;
    CGFloat popMenuButtonBottomPadding = [self popMenuButtonBottomPadding];
    
    NSInteger colnumIndex = 0;
    NSInteger rowIndex = 0;
    
    for (NSInteger index = 0; index < totalCount; index++) {
        colnumIndex = index % maxColumn;
        rowIndex = index / maxColumn;
        finalPopMenuX = (colnumIndex + 0.5) * self.menuButtonHorizontalMargin + colnumIndex * finalPopMenuWidth;
        finalPopMenuY = selfHeight - popMenuButtonBottomPadding - totalHeight + rowIndex * finalPopMenuHeight + (rowIndex - 1) * self.menuButtonVerticalMargin;
        CGRect finalPositionRect = CGRectMake(finalPopMenuX, finalPopMenuY, finalPopMenuWidth, finalPopMenuHeight);
        [finalPositionArray addObject:[NSValue valueWithCGRect:finalPositionRect]];
    }
    return finalPositionArray;
}

- (NSMutableArray<NSValue *> *)calculatePopMenuButtonsOriginPositionWithFinalPosition:(NSMutableArray<NSValue *> *)finalPositionArray {
    NSInteger totalCount = finalPositionArray.count;
    NSMutableArray<NSValue *> *originPositionArray  = [NSMutableArray arrayWithCapacity:totalCount];
    CGFloat difference = self.frame.size.height - [finalPositionArray.firstObject CGRectValue].origin.y;
    switch (self.showAnimationType) {
        case VVPopMenuViewShowAnimationTypeSina: {
            for (NSInteger index = 0; index < totalCount; index++) {
                CGRect finalPositionRect = [finalPositionArray[index] CGRectValue];
                CGRect originPositionRect = CGRectMake(finalPositionRect.origin.x, finalPositionRect.origin.y + difference, finalPositionRect.size.width, finalPositionRect.size.height);
                [originPositionArray addObject:[NSValue valueWithCGRect:originPositionRect]];
            }
            break;
        }
        case VVPopMenuViewShowAnimationTypeBottomRadiate: {
            for (NSInteger index = 0; index < totalCount; index++) {
                CGRect finalPositionRect = [finalPositionArray[index] CGRectValue];
                CGRect originPositionRect = CGRectMake(self.closeButton.center.x - finalPositionRect.size.height * 0.5, self.closeButton.center.y - finalPositionRect.size.width * 0.5, finalPositionRect.size.width, finalPositionRect.size.height);
                [originPositionArray addObject:[NSValue valueWithCGRect:originPositionRect]];
            }
            break;
        }
    }
    return originPositionArray;
}

@end
