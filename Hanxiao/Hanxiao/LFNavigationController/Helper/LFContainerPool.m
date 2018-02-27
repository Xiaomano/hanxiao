//
//  LFContainerPool.m
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import "LFContainerPool.h"
#import "LFContainerController.h"
#import "UIViewController+LFNavigationController.h"

//这里做为容器池，会重用容器，闭免频繁创建销毁容器带来的开销。 前期先暂时创建销毁，后期优化
@implementation LFContainerPool

-(LFContainerController *)reuseContainerWithController:(UIViewController *)viewController{
    LFContainerController *container = [[LFContainerController alloc] init];
    container.customerController = viewController;
    return container;
}

-(UIViewController *)restitutionContainer:(LFContainerController *)containerController{
//    UIViewController *vc =  containerController.customerController;
//    containerController.customerController = nil;
    return containerController;
}
@end
