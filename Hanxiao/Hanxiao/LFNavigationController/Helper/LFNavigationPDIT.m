//
//  LFNavigationPDIT.m
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import "LFNavigationPDIT.h"

#import <objc/runtime.h>

//#import "LFNavigationController+PDITSupper.h"

#import "LFRuntime.h"

//安全起见，因为是hook新对象，防止写越界，所以把delegate设置成动态属性
@implementation LFNavigationPDIT
@dynamic delegate;

-(void)setDelegate:(id<LFNavigationPDITDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

-(id<LFNavigationPDITDelegate>)delegate
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)cancelInteractiveTransition
{
    
    [super cancelInteractiveTransition];
    if ([self.delegate respondsToSelector:@selector(cancelInteractiveTransition)]) {
        [self.delegate cancelInteractiveTransition];
    }
    
}
- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    if ([self.delegate respondsToSelector:@selector(finishInteractiveTransition)]) {
        [self.delegate finishInteractiveTransition];
    }
}
-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    [super startInteractiveTransition:transitionContext];
    if ([self.delegate respondsToSelector:@selector(startInteractiveTransition:)]) {
        [self.delegate startInteractiveTransition:transitionContext];
    }
//    NSLog(@"transitionContext View = %@",transitionContext.containerView);
}
- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];
    if ([self.delegate respondsToSelector:@selector(updateInteractiveTransition:)]) {
        [self.delegate updateInteractiveTransition:percentComplete];
    }
}

+(void)hookObject:(id)obj
{
    NSString *className = NSStringFromClass([obj class]);
    
    NSString *hookClassName = [NSString stringWithFormat:@"_lf_hook_%@",className];
    
    object_setClass(obj, [self duplicateClass:[obj class] newClassName:hookClassName]);
}
@end
