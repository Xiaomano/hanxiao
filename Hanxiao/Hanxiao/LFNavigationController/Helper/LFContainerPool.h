//
//  LFContainerPool.h
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFContainerController;

@interface LFContainerPool : NSObject
-(LFContainerController *)reuseContainerWithController:(UIViewController *)viewController;
-(UIViewController *)restitutionContainer:(LFContainerController *)containerController;
@end
