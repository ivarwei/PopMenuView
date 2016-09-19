//
//  ViewController.m
//  VVPopMenuViewDemo
//
//  Created by 卫兵 on 16/9/12.
//  Copyright © 2016年 Jasonvvei. All rights reserved.
//

#import "ViewController.h"
#import "VVPopMenuView.h"
#import "TestTopView.h"

#define VVRandomColor ([UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0])

@interface ViewController () <VVPopMenuViewDataSource, VVPopMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *backgroundTypeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationTypeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *maxColumnSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *buttonCountSegment;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxColumnSegment.selectedSegmentIndex = 1;
    self.buttonCountSegment.selectedSegmentIndex = 3;
}

- (IBAction)shouAction:(id)sender {
    
    
    NSMutableArray<VVPopMenuModel *> *popMenuModelArray = [NSMutableArray array];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeDefault transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_idea" title:@"标题1" titleColor:VVRandomColor]];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeDefault transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_photo" title:@"标题2\n(多行内容)" titleColor:VVRandomColor]];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeBubble transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_camera" title:@"标题3" titleColor:VVRandomColor]];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeDefault transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_lbs" title:@"标题4" titleColor:VVRandomColor]];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeBubble transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_review" title:@"标题5" titleColor:VVRandomColor]];
    [popMenuModelArray addObject:[VVPopMenuModel popMenuModelWithTransitionType:VVPopMenuTransitionTypeDefault transitionTypeBubbleColor:nil
                                                                      imageName:@"tabbar_compose_more" title:@"标题6\n(多行内容)" titleColor:VVRandomColor]];
    
    VVPopMenuView *popMenuView = [VVPopMenuView sharedInstance];
    popMenuView.dataSource = self;
    popMenuView.delegate = self;
    // 背景类型、显示动画类型
    popMenuView.backgroundType = self.backgroundTypeSegment.selectedSegmentIndex;
    popMenuView.showAnimationType = self.animationTypeSegment.selectedSegmentIndex;
    [popMenuView showWithPopMenuModelArray:[popMenuModelArray subarrayWithRange:NSMakeRange(0, self.buttonCountSegment.selectedSegmentIndex + 3)]];
}

#pragma mark - VVPopMenuViewDataSource

- (CGSize)closeButtonSizeInPopMenuView:(VVPopMenuView *)popMenuView {
    return CGSizeMake(33, 33);
}

- (NSString *)closeButtonImageNameInPopMenuView:(VVPopMenuView *)popMenuView {
    return @"tabbar_compose_background_icon_add";
}

- (UIView *)topViewInPopMenuView:(VVPopMenuView *)popMenuView {
    return [TestTopView testTopView];
}

- (CGFloat)closeButtonBottomPaddingInPopMenuView:(VVPopMenuView *)popMenuView {
    return 22.0;
}

- (NSUInteger)popMenuMaxColumnInPopMenuView:(VVPopMenuView *)popMenuView {
    return self.maxColumnSegment.selectedSegmentIndex + 2;
}

- (CGFloat)popMenuButtonHorizontalMarginInPopMenuView:(VVPopMenuView *)popMenuView {
    if (popMenuView.maxColumn == 3) {
        return 5.0;
    } else if (popMenuView.maxColumn == 2) {
        return 50.0;
    }
    return 5.0;
}

#pragma mark - VVPopMenuViewDelegate

- (void)popMenuView:(VVPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"选择了: %@", @(index));
}

- (void)popMenuViewWillShow:(VVPopMenuView *)popMenuView {
    NSLog(@"popMenuViewWillShow");
}

- (void)popMenuViewDidShow:(VVPopMenuView *)popMenuView {
    NSLog(@"popMenuViewDidShow");
}

- (void)popMenuViewWillDisMiss:(VVPopMenuView *)popMenuView {
    NSLog(@"popMenuViewWillDisMiss");
}

- (void)popMenuViewDidDisMiss:(VVPopMenuView *)popMenuView {
    NSLog(@"popMenuViewDidDisMiss");
}

@end
