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

@property (nonatomic, weak) id<VVPopMenuViewDataSource> dataSource;
@property (nonatomic, weak) id<VVPopMenuViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray<VVPopMenuModel *> *popMenuModelArray;
@property (nonatomic, assign, readonly) NSInteger maxColumn; // 最大列数

+ (instancetype)sharedInstance;

- (void)showWithPopMenuModelArray:(NSArray<VVPopMenuModel *> *)popMenuModelArray;
- (void)disMiss;

@end

#pragma mark - VVPopMenuViewDataSource

@protocol VVPopMenuViewDataSource <NSObject>

@required
- (NSString *)closeButtonImageNameInPopMenuView:(VVPopMenuView *)popMenuView;

@optional
- (CGSize)closeButtonSizeInPopMenuView:(VVPopMenuView *)popMenuView;
- (CGFloat)closeButtonBottomPaddingInPopMenuView:(VVPopMenuView *)popMenuView;
- (CGFloat)popMenuButtonBottomPaddingInPopMenuView:(VVPopMenuView *)popMenuView;
- (NSArray<VVPopMenuModel *> *)popMenuModelArrayInPopMenuView:(VVPopMenuView *)tableView;

// button之间的间距和最大列数
- (CGFloat)popMenuButtonHorizontalMarginInPopMenuView:(VVPopMenuView *)popMenuView;
- (CGFloat)popMenuButtonVerticalMarginInPopMenuView:(VVPopMenuView *)popMenuView;
- (NSUInteger)popMenuMaxColumnInPopMenuView:(VVPopMenuView *)popMenuView;

// 顶部的topView
- (UIView *)topViewInPopMenuView:(VVPopMenuView *)popMenuView;
- (CGFloat)topViewTopInPopMenuView:(VVPopMenuView *)popMenuView;
- (CGFloat)topViewHeightInPopMenuView:(VVPopMenuView *)popMenuView;

@end

#pragma mark - VVPopMenuViewDelegate

@protocol VVPopMenuViewDelegate <NSObject>

@required
- (void)popMenuViewWillDisMiss:(VVPopMenuView *)popMenuView selectItemAtIndex:(NSInteger)index;
- (void)popMenuViewDidDisMiss:(VVPopMenuView *)popMenuView selectItemAtIndex:(NSInteger)index;

@optional
- (void)popMenuViewWillShow:(VVPopMenuView *)popMenuView;
- (void)popMenuViewDidShow:(VVPopMenuView *)popMenuView;

@end
