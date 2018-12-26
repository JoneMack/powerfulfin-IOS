//
//  KZAlertController.h
//  KZAlertControllerDemo
//
//  Created by Tintin on 2018/3/28.
//  Copyright © 2018年 kezhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZAlertView.h"

/**
 弹出框
 */
@interface KZAlertController : UIViewController

/**
 弹出窗内容的View。父类初始化完毕，子类自定定义大小和内容
 */
@property (nonatomic,strong,readonly)KZAlertView * contentView;

/**
 点击contentView以外的地方是否触发自动消失，默认是不触发
 */
@property (nonatomic,assign)BOOL dismissWhenClikBlankSpace;

/**
 展示AlertController
 @param controller 从哪个类中展示
 */
- (void)showAlertControllerFromController:(UIViewController *)controller;
/**
 退出展示框
 */
- (void)dismissViewController;


/**
 配置contentView动画类型，子类实现
 */
- (void)configContentView;


@end
