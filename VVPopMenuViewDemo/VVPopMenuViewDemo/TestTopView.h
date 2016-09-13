//
//  TestTopView.h
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/10.
//  Copyright © 2016年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
+ (instancetype)testTopView;

@end
