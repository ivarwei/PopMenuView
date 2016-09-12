//
//  VVPopMenuButton.h
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/5.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVPopMenuModel.h"

typedef void (^VVCompletionAnimationBlock)();

@interface VVPopMenuButton : UIButton

+ (instancetype __nonnull)popMenuButtonWithPopMenuModel:(VVPopMenuModel * __nonnull)popMenuModel;

@property (nonatomic, copy, nullable) VVCompletionAnimationBlock completionAnimationBlock;

- (void)selectdAnimation;
- (void)cancelAnimation;

@end
