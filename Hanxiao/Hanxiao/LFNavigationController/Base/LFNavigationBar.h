//
//  LFNavigationBar.h
//  LFNavigationController2
//
//  Created by 福有李 on 2017/11/23.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFNavigationController.h"

@protocol LFNavigationBarInteractiveTransition
@optional
-(void)cancelInteractiveTransition;
-(void)finishInteractiveTransition;
-(void)updateInteractiveTransition:(CGFloat)percentComplete;
-(void)startInteractiveTransition;
@end

@interface LFNavigationBar : UINavigationBar <LFNavigationBarInteractiveTransition>

@property (nonatomic,weak) UINavigationController *owner;

@property (nonatomic,readonly) NSMutableArray *animatedViews;//需要变换的动画view

-(void)lf_updateViews:(UINavigationItem *)item;
-(void)lf_updateViews:(UINavigationItem *)item animated:(BOOL)animated;

-(void)lf_willTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye;

-(void)lf_didTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye;

@end
