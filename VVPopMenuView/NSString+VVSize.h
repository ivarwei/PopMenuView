//
//  NSString+VVSize.h
//  GBPopMenuView
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by 卫兵 on 16/9/5.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (VVSize)

- (CGFloat)vv_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGFloat)vv_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGSize)vv_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGSize)vv_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

+ (NSString *)vv_reverseString:(NSString *)strSrc;

@end
