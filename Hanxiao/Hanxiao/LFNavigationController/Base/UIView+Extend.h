//
//  UIView+Ext.h
//  YiAEntertainment
//
//  Created by 福有李 on 15/9/21.
//  Copyright (c) 2015年 YiA. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (Ext_ib)

@property (nonatomic) IBInspectable UIColor *shadowColor;

@property (nonatomic) IBInspectable float shadowOpacity;

@property (nonatomic) IBInspectable float shadowRadius;

@property (nonatomic) IBInspectable float cornerRadius;

@property (nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic) IBInspectable float borderWidth;

@property (nonatomic) IBInspectable BOOL lf_exclusiveTouch;


@end
