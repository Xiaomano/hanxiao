//
//  UINavigationItem+AttributeExt.m
//  BluChat
//
//  Created by 福有李 on 2017/11/9.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import "UINavigationItem+AttributeExt.h"
#import "LFNavigationController.h"
#import "LFRuntime.h"


@implementation UINavigationItem (AttributeExt)
@dynamic navigationHidden;
@dynamic owner;
@dynamic tintColor;
@dynamic backImage;
@dynamic backgroundColor;

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    objc_setAssociatedObject(self, @selector(backgroundColor), backgroundColor, OBJC_ASSOCIATION_RETAIN);
    [self renderViews];
}
//-(void)setBackgroundColor:(UIColor *)backgroundColor{
//    objc_setAssociatedObject(self, @selector(backgroundColor), backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

-(UIColor *)backgroundColor{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color != nil || self == [[self class] appearance]) {
        return color;
    }
    return  [UINavigationItem appearance].backgroundColor;
}

-(UIColor *)tintColor{

    if (self.navigationHidden) {
        return nil;
    }
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color != nil || self == [[self class] appearance]) {
        return color;
    }
    return  [UINavigationItem appearance].tintColor;
}

-(void)setTintColor:(UIColor *)tintColor{
    objc_setAssociatedObject(self, @selector(tintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self renderViews];
}

-(BOOL)navigationHidden{
    
    NSNumber *isHidden = objc_getAssociatedObject(self, _cmd);
    if (isHidden != nil || self == [[self class] appearance]) {
        return [isHidden boolValue];
    }
    return [UINavigationItem appearance].navigationHidden;
}

-(void)setNavigationHidden:(BOOL)navigationHidden{
    objc_setAssociatedObject(self, @selector(navigationHidden), @(navigationHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self renderViews];
}

-(void)setBackImage:(UIImage *)backImage{
    
    
    objc_setAssociatedObject(self, @selector(backImage), backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self renderViews];
}
-(UIImage *)backImage{
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    
    if (image != nil || self == [[self class] appearance]) {
        return image;
    }
    return [UINavigationItem appearance].backImage;
}

-(UIViewController *)owner{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setOwner:(UIViewController *)owner{
    objc_setAssociatedObject(self, @selector(owner), owner, OBJC_ASSOCIATION_ASSIGN);
}

-(void)renderViews{
    [self renderViewsAnimated:NO];
}
-(void)renderViewsAnimated:(BOOL)animated{
    LFNavigationController *navigationController = (LFNavigationController *)[self.owner navigationController];
    [navigationController lf_renderViewControllerBar:self.owner animated:animated];
}

-(void)lf_setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem{
    [self lf_setBackBarButtonItem:backBarButtonItem];
    [self renderViews];
}

+(instancetype)appearance{
    static UINavigationItem *_item = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _item = [[self alloc] init];
    });
    return _item;
}

-(void)lf_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    [self lf_setLeftBarButtonItem:leftBarButtonItem];
    [self renderViews];
}


+(void)load{
    [self exchangeInstanceMethod:@selector(lf_setLeftBarButtonItem:) to:@selector(setLeftBarButtonItem:)];
}

@end
