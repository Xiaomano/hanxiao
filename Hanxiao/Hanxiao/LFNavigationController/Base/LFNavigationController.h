//
//  LFNavigationController.h
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LFNavigationControllerTransformTypePush,
    LFNavigationControllerTransformTypePop
} LFNavigationControllerTransformType;
@interface LFNavigationController : UINavigationController

-(void)lf_renderViewControllerBar:(UIViewController *)viewController;
-(void)lf_renderViewControllerBar:(UIViewController *)viewController animated:(BOOL)animated;

-(void)renderViewController:(UIViewController *)viewController animated:(BOOL)animated;//重载此方法，实现navigation显示逻辑

-(void)lf_willTransformToController:(UIViewController *)viewController animated:(BOOL)animated type:(LFNavigationControllerTransformType)type stacks:(NSArray <UIViewController *> *)stacks; //stack不包括top vc

-(void)lf_didTransformToController:(UIViewController *)viewController animated:(BOOL)animated type:(LFNavigationControllerTransformType)type stacks:(NSArray <UIViewController *> *)stacks;
//-(void)lf_didPushViewControllerAnimated:(UIViewController *)viewController animated:(BOOL)animated;//重写此方法， 写动画
//-(void)lf_didPopViewControllerAnimated:(UIViewController *)viewControoler animated:(BOOL)animated;
//
//-(void)lf_willPushViewControllerAnimated:(UIViewController *)viewController animated:(BOOL)animated;//重写此方法， 写动画
//-(void)lf_willPopViewControllerAnimated:(UIViewController *)viewControoler animated:(BOOL)animated;


-(Class)lf_navigationBar_Class;

//-(Class)nav
//-(void)lf_change_navigation_status_from_controller:(UIViewController *)viewController execBlock:(dispatch_block_t)block;
@end
