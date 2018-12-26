//
//  KZAlertView.h
//  KZAlertControllerDemo
//
//  Created by Tintin on 2018/4/2.
//  Copyright © 2018年 kezhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZAlertViewAnimated.h"
@interface KZAlertView : UIView
@property (nonatomic,strong)id<KZAlertViewAnimated> alertAnimation;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;

@end
