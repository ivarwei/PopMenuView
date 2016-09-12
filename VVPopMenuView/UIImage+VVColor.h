//
//  UIImage+VVColor.h
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/5.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (VVColor)

+ (UIImage *)vv_imageWithColor:(UIColor *)color;
- (UIColor *)vv_colorAtPixel:(CGPoint)point;
- (BOOL)vv_hasAlphaChannel;    //返回该图片是否有透明度通道

@end
