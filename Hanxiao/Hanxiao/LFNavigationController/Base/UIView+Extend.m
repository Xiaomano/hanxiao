//
//  UIView+Ext.m
//  YiAEntertainment
//
//  Created by 福有李 on 15/9/21.
//  Copyright (c) 2015年 YiA. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Ext_ib)

@dynamic shadowColor;
@dynamic shadowOpacity;
@dynamic shadowRadius;

@dynamic cornerRadius;

-(void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

-(UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

-(void)setShadowOpacity:(float)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

- (float)shadowOpacity
{
    return self.layer.shadowOpacity;
}

-(void)setShadowRadius:(float)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

-(float)shadowRadius
{
    return self.layer.shadowRadius;
}

-(void)setCornerRadius:(float)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(float)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(float)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

-(float)borderWidth
{
    return self.layer.borderWidth*[UIScreen mainScreen].scale;
}

-(void)setLf_exclusiveTouch:(BOOL)lf_exclusiveTouch{
    self.exclusiveTouch = lf_exclusiveTouch;
}

-(BOOL)lf_exclusiveTouch{
    return self.exclusiveTouch;
}

@end
