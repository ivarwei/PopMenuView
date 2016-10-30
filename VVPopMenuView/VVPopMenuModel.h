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

@property (nonatomic, assign)   VVPopMenuTransitionType transitionType;
@property (nonatomic, strong)   UIColor                 *transitionTypeBubbleColor;
@property (nonatomic, strong)   UIImage                 *placeholdImage;
@property (nonatomic, strong)   id                      image;
@property (nonatomic, copy)     NSString                *title;
@property (nonatomic, strong)   UIColor                 *titleColor;
@property (nonatomic, strong)   id                      otherInfo;

+ (instancetype)popMenuModelWithTransitionType:(VVPopMenuTransitionType)transitionType
                     transitionTypeBubbleColor:(UIColor *)transitionTypeBubbleColor
                                placeholdImage:(UIImage *)placeholdImage
                                         image:(id)image
                                         title:(NSString *)title
                                    titleColor:(UIColor *)titleColor
                                     otherInfo:(id)otherInfo;

@end
