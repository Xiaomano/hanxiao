//
//  UINavigationItem+AttributeExt.h
//  BluChat
//
//  Created by 福有李 on 2017/11/9.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (AttributeExt) <UIAppearance>

@property (nonatomic,assign) IBInspectable BOOL navigationHidden;
@property (nonatomic,strong) IBInspectable UIColor *tintColor;
@property (nonatomic,strong) IBInspectable UIImage *backImage;
@property (nonatomic,strong) IBInspectable UIColor *backgroundColor;
//private
@property (nonatomic,weak) UIViewController *owner;

@end
