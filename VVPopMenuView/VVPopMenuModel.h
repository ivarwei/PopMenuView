//
//  VVPopMenuModel.h
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/8.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const VVPopMenuViewAnimationDefaultDuration;

typedef NS_ENUM(NSUInteger, VVPopMenuTransitionType) {
    VVPopMenuTransitionTypeDefault = 0,
    VVPopMenuTransitionTypeBubble,
};

@interface VVPopMenuModel : NSObject

@property (nonatomic, assign          ) VVPopMenuTransitionType transitionType;
@property (nonatomic, strong, nullable) UIColor                 *transitionTypeBubbleColor;
@property (nonatomic, copy, nonnull   ) NSString                *imageName;
@property (nonatomic, copy, nullable  ) NSString                *title;
@property (nonatomic, strong, nullable) UIColor                 *titleColor;

+ (instancetype __nonnull)popMenuModelWithTransitionType:(VVPopMenuTransitionType)transitionType
                               transitionTypeBubbleColor:(UIColor * __nullable)transitionTypeBubbleColor
                                               imageName:(NSString * __nonnull)imageName
                                                   title:(NSString * __nullable)title
                                              titleColor:(UIColor * __nullable)titleColor;

@end
