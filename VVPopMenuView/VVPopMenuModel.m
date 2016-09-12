//
//  VVPopMenuModel.m
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/8.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import "VVPopMenuModel.h"

CGFloat const VVPopMenuViewAnimationDefaultDuration    = 0.25;

@implementation VVPopMenuModel

- (instancetype)initWithTransitionType:(VVPopMenuTransitionType)transitionType
             transitionTypeBubbleColor:(UIColor *)transitionTypeBubbleColor
                             imageName:(NSString *)imageName
                                 title:(NSString *)title
                            titleColor:(UIColor *)titleColor {
    if (self = [super init]) {
        self.transitionType            = transitionType;
        self.transitionTypeBubbleColor = transitionTypeBubbleColor;
        self.imageName                 = imageName;
        self.title                     = title;
        self.titleColor                = titleColor;
    }
    return self;
}

+ (instancetype)popMenuModelWithTransitionType:(VVPopMenuTransitionType)transitionType transitionTypeBubbleColor:(UIColor *)transitionTypeBubbleColor imageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)titleColor {
    VVPopMenuModel *popMenuModel = [[self alloc] initWithTransitionType:transitionType transitionTypeBubbleColor:transitionTypeBubbleColor imageName:imageName title:title titleColor:titleColor];
    return popMenuModel;
}

@end
