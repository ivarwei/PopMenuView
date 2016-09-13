//
//  TestTopView.m
//  GBPopMenuView
//
//  Created by 卫兵 on 16/9/10.
//  Copyright © 2016年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "TestTopView.h"

@interface TestTopView ()

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation TestTopView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.index = 0;
}

+ (instancetype)testTopView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeImage) userInfo:nil repeats:true];
    [self changeImage];
}


- (void)changeImage {
    self.index++;
    if (self.index > 6) {
        self.index = 1;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.imageView.alpha = 0;
    } completion:^(BOOL finished) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img-%zd",weakSelf.index]];
        weakSelf.imageView.image = image;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.imageView.alpha = 1;
        }];
    }];
}

@end
