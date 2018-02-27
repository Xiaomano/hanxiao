//
//  UIGestureRecognizer+Target.m
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import "UIGestureRecognizer+Target.h"

@interface LFTargetSelector : NSObject
@property (nonatomic,weak) id target;
@property (nonatomic,assign) SEL selector;
@end

@implementation LFTargetSelector
@end

LFTargetSelector *LFMakeTargetSelector(id target,SEL sel){
    LFTargetSelector *ts = [[LFTargetSelector alloc] init];
    ts.target = target;
    ts.selector = sel;
    return ts;
}

@interface UIGestureRecognizer (_privateTarget)
@property (nonatomic,readwrite) NSMutableArray *innerStore;
@end

@implementation UIGestureRecognizer (_privateTarget)
@dynamic innerStore;
-(NSMutableArray *)innerStore
{
    NSMutableArray *innerStore = objc_getAssociatedObject(self, _cmd);
    
    if (innerStore == nil) {
        @synchronized(self) {
            if (innerStore == nil) {
                innerStore = [NSMutableArray array];
                self.innerStore = innerStore;
            }
        }
    }
    return innerStore;
}

-(void)setInnerStore:(NSMutableDictionary *)innerStore
{
    objc_setAssociatedObject(self, @selector(innerStore), innerStore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

NSString *NSStringFromObjectAddress(id obj)
{
    if (obj == nil) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%x",(int)(__bridge void *)obj];
}
@implementation UIGestureRecognizer (Target)
@dynamic allTargets;

-(NSArray *)allTargets
{
    NSMutableArray *allTargets = [NSMutableArray array];
    
    for (LFTargetSelector *ts in self.innerStore) {
        if (ts.target != nil) {
            [allTargets addObject:ts.target];
        }
    }
    return allTargets;
}

-(instancetype)_initWithTarget:(id)target action:(SEL)action
{
    self = [self _initWithTarget:target action:action];
    if (self) {
        if (target != nil) {
            [self.innerStore addObject:LFMakeTargetSelector(target, action)];
        }
        
    }
    return self;
}

-(void)_addTarget:(id)target action:(SEL)action
{
    if (target != nil) {
        [self.innerStore addObject:LFMakeTargetSelector(target, action)];
    }
    [self _addTarget:target action:action];
}

-(void)_removeTarget:(id)target action:(SEL)action
{
    if (target == nil) {
        self.innerStore = nil;
    }else{
        
        NSMutableArray *willDeleteObject = [NSMutableArray array];
        for (LFTargetSelector *ts in self.innerStore) {
            if (ts == nil) {
                [willDeleteObject addObject:ts];
            }else{
                if (ts == target && [NSStringFromSelector(action) isEqualToString:NSStringFromSelector(ts.selector)]) {
                    [willDeleteObject addObject:ts];
                }
            }
        }
        
        for (id obj in willDeleteObject) {
            [self.innerStore removeObject:obj];
        }
    }
    [self _removeTarget:target action:action];
}
- (void)_dealloc
{
    self.innerStore = nil;
    [self _dealloc];
}

@end


@interface UIGestureRecognizer_Target_Loader : NSObject
@end
@implementation UIGestureRecognizer_Target_Loader
+(void)load
{
    [UIGestureRecognizer exchangeInstanceMethod:@selector(initWithTarget:action:) to:@selector(_initWithTarget:action:)];
    [UIGestureRecognizer exchangeInstanceMethod:@selector(addTarget:action:) to:@selector(_addTarget:action:)];
    [UIGestureRecognizer exchangeInstanceMethod:@selector(_removeTarget:action:) to:@selector(removeTarget:action:)];
    [UIGestureRecognizer exchangeInstanceMethod:NSSelectorFromString(@"dealloc") to:@selector(_dealloc)];
}
@end
