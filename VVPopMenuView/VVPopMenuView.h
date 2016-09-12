//
//  VVPopMenuView.h
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/8.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVPopMenuModel.h"

@class VVPopMenuView;
@protocol VVPopMenuViewDataSource, VVPopMenuViewDelegate;

#pragma mark - ENUM

typedef NS_ENUM(NSUInteger, VVPopMenuViewShowAnimationType) {
    VVPopMenuViewShowAnimationTypeSina = 0,
    VVPopMenuViewShowAnimationTypeBottomRadiate,
};

/**
 *  背景的样式种类
 */
typedef NS_ENUM(NSUInteger, VVPopMenuViewBackgroundType) {
    /** dark模糊背景 */
    VVPopMenuViewBackgroundTypeDarkBlur = 0,
    /** 偏黑半透明 */
    VVPopMenuViewBackgroundTypeDarkTranslucent,
    /** light模糊 */
    VVPopMenuViewBackgroundTypeLightBlur,
    /** 偏白半透明 */
    VVPopMenuViewBackgroundTypeLightTranslucent,
    /** 白~黑渐变色 */
    VVPopMenuViewBackgroundTypeGradient,
};

#pragma mark - VVPopMenuView

@interface VVPopMenuView : UIView

@property (nonatomic, assign) VVPopMenuViewBackgroundType backgroundType;
@property (nonatomic, assign) VVPopMenuViewShowAnimationType showAnimationType;

@property (nonatomic, weak, nullable) id<VVPopMenuViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<VVPopMenuViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger maxColumn; // 最大列数

+ (instancetype __nonnull)sharedInstance;

- (void)showWithPopMenuModelArray:(NSArray<VVPopMenuModel *> * __nullable)popMenuModelArray;
- (void)disMiss;

@end

#pragma mark - VVPopMenuViewDataSource

@protocol VVPopMenuViewDataSource <NSObject>

@required
- (NSString * __nonnull)closeButtonImageNameInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;

@optional
- (CGFloat)closeButtonBottomPaddingInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (CGFloat)popMenuButtonBottomPaddingInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (NSArray<VVPopMenuModel *> * __nonnull)popMenuModelArrayInPopMenuView:(VVPopMenuView * __nonnull)tableView;

// button之间的间距和最大列数
- (CGFloat)popMenuButtonHorizontalMarginInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (CGFloat)popMenuButtonVerticalMarginInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (NSUInteger)popMenuMaxColumnInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;

// 顶部的topView
- (UIView * __nullable)topViewInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (CGFloat)topViewTopInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;
- (CGFloat)topViewHeightInPopMenuView:(VVPopMenuView * __nonnull)popMenuView;

@end

#pragma mark - VVPopMenuViewDelegate

@protocol VVPopMenuViewDelegate <NSObject>

@required
- (void)popMenuView:(VVPopMenuView * __nonnull)popMenuView didSelectItemAtIndex:(NSUInteger)index;

@optional
- (void)popMenuViewWillShow:(VVPopMenuView * __nonnull)popMenuView;
- (void)popMenuViewDidShow:(VVPopMenuView * __nonnull)popMenuView;
- (void)popMenuViewWillDisMiss:(VVPopMenuView * __nonnull)popMenuView;
- (void)popMenuViewDidDisMiss:(VVPopMenuView * __nonnull)popMenuView;

@end
