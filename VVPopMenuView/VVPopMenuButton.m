//
//  VVPopMenuButton.m
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/5.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import "VVPopMenuButton.h"
#import "UIImage+VVColor.h"
#import "NSString+VVSize.h"
#import <SDWebImage/UIButton+WebCache.h>

static NSString * const VVPopMenuButtonSelectdAnimationKey = @"VVPopMenuButtonSelectdAnimationKey";

static NSString * const VVTransformScaleKeyPathKey         = @"transform.scale";
static NSString * const VVTransformOpacityKeyPathKey       = @"opacity";

@interface VVPopMenuButton () <CAAnimationDelegate>

@property (nonatomic, strong) VVPopMenuModel *popMenuModel;

@end

@implementation VVPopMenuButton

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.adjustsImageWhenHighlighted = NO;
    [self addTarget:self action:@selector(scaleToLarge) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize selfSize = self.bounds.size;
    CGFloat imageAndTitlePadding = 10.0;
    CGFloat textLineHeight = [@"一行内容高度" vv_heightWithFont:self.titleLabel.font constrainedToWidth:MAXFLOAT];
    
    CGFloat imageViewWidth = selfSize.width / 1.7;
    CGFloat imageViewHeight = imageViewWidth;
    CGFloat textLabelWidth = selfSize.width;
    CGFloat textLabelHeight = [self.titleLabel.text vv_heightWithFont:self.titleLabel.font constrainedToWidth:textLabelWidth];
    
    CGFloat imageViewX = (selfSize.width - imageViewWidth) / 2;
    CGFloat imageViewY = (selfSize.height - imageViewHeight - textLineHeight - imageAndTitlePadding) / 2;
    CGFloat textLabelX = 0.0;
    CGFloat textLabelY = imageViewY + imageViewHeight + imageAndTitlePadding;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    self.titleLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelWidth, textLabelHeight);
    self.imageView.layer.cornerRadius = imageViewWidth * 0.5;
}

+ (instancetype)popMenuButtonWithPopMenuModel:(VVPopMenuModel *)popMenuModel {
    VVPopMenuButton *popMenuButton = [[self alloc] init];
    popMenuButton.popMenuModel = popMenuModel;
    return popMenuButton;
}

#pragma mark - Public Method

- (void)selectdAnimation {
    self.userInteractionEnabled = NO;
    switch (self.popMenuModel.transitionType) {
        case VVPopMenuTransitionTypeDefault: {
            CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:VVTransformScaleKeyPathKey];
            scaleAnimation.delegate = self;
            scaleAnimation.duration = VVPopMenuViewAnimationDefaultDuration;
            scaleAnimation.repeatCount = 0;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fromValue = @1;
            scaleAnimation.toValue = @1.4;
            
            CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:VVTransformOpacityKeyPathKey];
            opacityAnimation.delegate = self;
            opacityAnimation.duration = VVPopMenuViewAnimationDefaultDuration;
            opacityAnimation.repeatCount = 0;
            opacityAnimation.removedOnCompletion = NO;
            opacityAnimation.fillMode = kCAFillModeForwards;
            opacityAnimation.autoreverses = NO;
            opacityAnimation.fromValue = @1;
            opacityAnimation.toValue = @0;
            
            [self.layer addAnimation:scaleAnimation forKey:VVPopMenuButtonSelectdAnimationKey];
            [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
            break;
        }
        case VVPopMenuTransitionTypeBubble: {
            self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
            UIColor* color = [self.imageView.image vv_colorAtPixel:CGPointMake(50, 20)];
            [self setBackgroundColor:color];
            UILabel* textLabel = [self viewWithTag:21];
            textLabel.text = @"";
            [self setTitle:@"" forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateNormal];
            
            CABasicAnimation* expandAnim = [CABasicAnimation animationWithKeyPath:VVTransformScaleKeyPathKey];
            expandAnim.fromValue = @(1.0);
            expandAnim.toValue = @(33.0);
            expandAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.95:0.02:1:0.05];
            expandAnim.duration = VVPopMenuViewAnimationDefaultDuration;
            expandAnim.delegate = self;
            expandAnim.fillMode = kCAFillModeForwards;
            expandAnim.removedOnCompletion = NO;
            expandAnim.autoreverses = NO;
            [self.layer addAnimation:expandAnim forKey:VVPopMenuButtonSelectdAnimationKey];
            break;
        }
    }
}

- (void)cancelAnimation {
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:VVTransformScaleKeyPathKey];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = VVPopMenuViewAnimationDefaultDuration;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.2;
    
    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:VVTransformOpacityKeyPathKey];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = VVPopMenuViewAnimationDefaultDuration;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    // CGAffineTransformIdentity
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

#pragma mark - Event Method

- (void)scaleToLarge {
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:VVTransformScaleKeyPathKey];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.2f];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault {
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:VVTransformScaleKeyPathKey];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.2f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.layer animationForKey:VVPopMenuButtonSelectdAnimationKey]) {
        self.userInteractionEnabled = YES;
        if (flag == YES) {
            self.completionAnimationBlock ? self.completionAnimationBlock() : nil;
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf stopAnimation];
            });
        }
    }
}

- (void)stopAnimation {
    [self.layer removeAllAnimations];
}

#pragma mark - Property Method

- (void)setPopMenuModel:(VVPopMenuModel *)popMenuModel {
    _popMenuModel = popMenuModel;
    if ([popMenuModel.image isKindOfClass:[UIImage class]]) {
        [self setImage:popMenuModel.image forState:UIControlStateNormal];
    } else if ([popMenuModel.image isKindOfClass:[NSString class]]) {
        [self sd_setImageWithURL:[NSURL URLWithString:popMenuModel.image] forState:UIControlStateNormal placeholderImage:popMenuModel.placeholdImage];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self setTitle:popMenuModel.title forState:UIControlStateNormal];
    if (popMenuModel.titleColor != nil) {
        [self setTitleColor:popMenuModel.titleColor forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

@end
