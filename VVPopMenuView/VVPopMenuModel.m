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
                        placeholdImage:(UIImage *)placeholdImage
                                 image:(id)image
                                 title:(NSString *)title
                            titleColor:(UIColor *)titleColor
                             otherInfo:(id)otherInfo {
    if (self = [super init]) {
        self.transitionType             = transitionType;
        self.transitionTypeBubbleColor  = transitionTypeBubbleColor;
        self.placeholdImage             = placeholdImage;
        self.image                      = image;
        self.title                      = title;
        self.titleColor                 = titleColor;
        self.otherInfo                  = otherInfo;
    }
    return self;
}

+ (instancetype)popMenuModelWithTransitionType:(VVPopMenuTransitionType)transitionType
                     transitionTypeBubbleColor:(UIColor *)transitionTypeBubbleColor
                                placeholdImage:(UIImage *)placeholdImage
                                         image:(id)image
                                         title:(NSString *)title
                                    titleColor:(UIColor *)titleColor
                                     otherInfo:(id)otherInfo {
    VVPopMenuModel *popMenuModel = [[self alloc] initWithTransitionType:transitionType
                                              transitionTypeBubbleColor:transitionTypeBubbleColor
                                                         placeholdImage:placeholdImage
                                                                  image:image
                                                                  title:title
                                                             titleColor:titleColor
                                                              otherInfo:otherInfo];
    return popMenuModel;
}

@end
