//
//  KZAlertViewAnimated.h
//  KZAlertControllerDemo
//
//  Created by Tintin on 2018/4/2.
//  Copyright © 2018年 kezhan. All rights reserved.
//


#import <UIKit/UIKit.h>
#ifndef kScreenWidth
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef kScreenHeight
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

@protocol KZAlertViewAnimated <NSObject>
@optional
- (void)deviceOrientationDidChanged:(UIDeviceOrientation)orientation;
@required
@property (nonatomic,weak)UIView * contentView;
@property (nonatomic,assign)CGSize targetSize;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@optional
- (instancetype)initWithContentView:(UIView *)contentView;
@end
