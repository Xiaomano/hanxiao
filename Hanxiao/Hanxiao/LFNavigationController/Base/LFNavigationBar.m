//
//  LFNavigationBar.m
//  LFNavigationController2
//
//  Created by 福有李 on 2017/11/23.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import "LFNavigationBar.h"

@interface UINavigationBar (AutoLayoutFix)
@end

@implementation UINavigationBar (AutoLayoutFix)

-(void)addConstraint:(NSLayoutConstraint *)constraint{
    [super addConstraint:constraint];
}

-(void)addConstraints:(NSArray<__kindof NSLayoutConstraint *> *)constraints{
    [super addConstraints:constraints];
}

@end

@implementation LFNavigationBar
@synthesize animatedViews = _animatedViews;
-(NSMutableArray *)animatedViews{
    if (_animatedViews == nil) {
        @synchronized(self){
            if (_animatedViews == nil) {
                _animatedViews = [NSMutableArray array];
            }
        }
    }
    return _animatedViews;
}
-(void)lf_updateViews:(UINavigationItem *)item{
    [self lf_updateViews:item animated:NO];
}

-(void)lf_updateViews:(UINavigationItem *)item animated:(BOOL)animated{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)startInteractiveTransition{
    for (UIView *view in self.animatedViews) {
        view.layer.speed = 0;
        view.layer.timeOffset = 0;
    }
}

-(void)updateInteractiveTransition:(CGFloat)percentComplete{
    float value = percentComplete * UINavigationControllerHideShowBarDuration;
    if (value < 0) {
        value = 0;
    }
    
    for (UIView *view in self.animatedViews) {
        view.layer.timeOffset = value;//percentComplete * UINavigationControllerHideShowBarDuration;
    }
}

-(void)cancelInteractiveTransition{
    for (UIView *view in self.animatedViews) {
        view.layer.speed = 1;
        [view.layer removeAllAnimations];
    }
}

-(void)finishInteractiveTransition{
    for (UIView *view in self.animatedViews) {
        view.layer.speed = 1;
        [view.layer removeAllAnimations];
    }
}

-(void)lf_willTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye{
    
}

-(void)lf_didTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye{
    
}

@end
