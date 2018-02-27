//
//  LFNavigationController.m
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import "LFNavigationController.h"
#import "LFContainerPool.h"
#import "LFContainerController.h"
#import "UIViewController+LFNavigationController.h"
#import "UINavigationItem+AttributeExt.h"
#import "LFNavigationPDIT.h"
#import "UIGestureRecognizer+Target.h"
#import "LFNavigationBar.h"
//#import "LFNavigationBar.h"

@interface LFNavigationController () <UINavigationControllerDelegate,LFNavigationPDITDelegate>{
    __weak UIViewController *_lastPopController;
}
@property (nonatomic,readonly) LFContainerPool *containerPool; //容器池
@property (nonatomic,weak) LFNavigationPDIT *pditHandle;
@end

@implementation LFNavigationController
@synthesize containerPool = _containerPool;

-(LFContainerPool *)containerPool{
    if (_containerPool == nil) { //thread safe
        @synchronized(self){
            if (_containerPool == nil) {
                _containerPool = [[LFContainerPool alloc] init];
            }
        }
    }
    return _containerPool;
}

#pragma mark 创建指定颜色的图像
-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    if (![rootViewController isMemberOfClass:[LFContainerController class]]) {
        rootViewController = [self.containerPool reuseContainerWithController:rootViewController];
    }
    self = [self initWithNavigationBarClass:[self lf_navigationBar_Class] toolbarClass:[UIToolbar class]];
    
    if (self) {
        [self _cover_init];
        [self setViewControllers:@[rootViewController]];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self _cover_init];
    [self setViewControllers:@[self.topViewController]];
}

-(void)_cover_init{
    ((LFNavigationBar *)self.navigationBar).owner = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationBar setBackIndicatorImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationBar setBackIndicatorTransitionMaskImage:[self createImageWithColor:[UIColor clearColor]]];

    //hook pop gesture transform
    for (id item in self.interactivePopGestureRecognizer.allTargets) {
        
        if ([item isKindOfClass:[UIPercentDrivenInteractiveTransition class]]) {
            //hook该类
            [LFNavigationPDIT hookObject:item];
            self.pditHandle = item;
            self.pditHandle.delegate = self;
            
        }
    }
    self.delegate = self;
}



- (void)didReceiveMemoryWarning {
    //dealloc pool idle container
    [super didReceiveMemoryWarning];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    LFContainerController *container = [self.containerPool reuseContainerWithController:viewController];
    [container view];
    
    NSArray *stacks = [super viewControllers];
    [self lf_willTransformToController:container animated:animated type:LFNavigationControllerTransformTypePush stacks:stacks];
    [super pushViewController:container animated:YES];
    [self lf_didTransformToController:container animated:animated type:LFNavigationControllerTransformTypePush stacks:stacks];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    NSArray <LFContainerController *> *viewControllers = [super viewControllers];
    
    if (viewControllers.count <= 1) {
        return nil;
    }
    NSMutableArray *stacks = [NSMutableArray arrayWithArray:[super viewControllers]];
    [stacks removeLastObject];
    
    LFContainerController *container = viewControllers[viewControllers.count -2];
    [self lf_willTransformToController:container animated:animated type:LFNavigationControllerTransformTypePop stacks:stacks];
    LFContainerController *last = (LFContainerController *)[super popViewControllerAnimated:animated];
    [self lf_didTransformToController:container animated:animated type:LFNavigationControllerTransformTypePop stacks:stacks];
    _lastPopController = last;
    return container;
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (![viewController isMemberOfClass:[LFContainerController class]]) {
        for (LFContainerController *container in [super viewControllers]) {
            if (container.customerController == viewController) {
                viewController = container;
                break;
            }
        }
    }
    
    NSArray *viewControllers =[super viewControllers];
    NSInteger index = [viewControllers indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    NSArray *stacks = [viewControllers subarrayWithRange:NSMakeRange(0, index)];
    
    
    [self lf_willTransformToController:viewController animated:animated type:LFNavigationControllerTransformTypePop stacks:stacks];
    NSArray *result = [super popToViewController:viewController animated:animated];
    [self lf_didTransformToController:viewController animated:animated type:LFNavigationControllerTransformTypePop stacks:stacks];
    return result;
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    [self lf_willTransformToController:[super viewControllers].firstObject animated:animated type:LFNavigationControllerTransformTypePop stacks:@[]];
    NSArray *result = [super popToRootViewControllerAnimated:animated];
    [self lf_didTransformToController:[super viewControllers].firstObject animated:animated type:LFNavigationControllerTransformTypePop stacks:@[]];
    return result;
}



-(NSArray<UIViewController *> *)viewControllers{
    NSArray<UIViewController *> *viewControllers = [super viewControllers];
    NSMutableArray *results = [NSMutableArray array];
    for (LFContainerController *container in viewControllers) {
        [results addObject: container.customerController];
    }

    return results;
}

-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    
    
    
//    NSKeyValueChangeNewKey
//    NSArray <LFContainerController *>* containers = [super viewControllers];
    viewControllers = [self packageViewControllers:viewControllers];
    
    NSArray *stacks = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)];
    [self lf_willTransformToController:viewControllers.lastObject animated:animated type:LFNavigationControllerTransformTypePush stacks:stacks];
    
    [super setViewControllers:viewControllers animated:animated];

    [self lf_didTransformToController:viewControllers.lastObject animated:animated type:LFNavigationControllerTransformTypePush stacks:stacks];
    
}

-(NSArray <UIViewController *> *)packageViewControllers:(NSArray <UIViewController *> *)viewControllers{
    NSMutableArray *results = [NSMutableArray array];
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isMemberOfClass:[LFContainerController class]]) {
            [results addObject:viewController];
        }else{
            if (viewController.containerController != nil) {
                [results addObject:viewController.containerController];
            }else{
                [results addObject:[self.containerPool reuseContainerWithController:viewController]];
            }
        }
        
    }
    return results;
}
#pragma mark delegate 子类
-(void)cancelInteractiveTransition{ //再这里等， 同步状态
    
    [self renderViewController:_lastPopController];
    if ([self.navigationBar respondsToSelector:@selector(cancelInteractiveTransition)]) {
        LFNavigationBar* obj = (LFNavigationBar *)(self.navigationBar);
        [obj cancelInteractiveTransition];
    }
    
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if ([self.navigationBar respondsToSelector:@selector(startInteractiveTransition)]) {
        id<LFNavigationBarInteractiveTransition> obj = (id<LFNavigationBarInteractiveTransition>)self.navigationBar;
        [obj startInteractiveTransition];
    }
}
-(void)finishInteractiveTransition{

    [self renderViewController:self.visibleViewController];
    if ([self.navigationBar respondsToSelector:@selector(finishInteractiveTransition)]) {
        id<LFNavigationBarInteractiveTransition> obj = (id<LFNavigationBarInteractiveTransition>)self.navigationBar;
        [obj finishInteractiveTransition];
    }
}
-(void)updateInteractiveTransition:(CGFloat)percentComplete{
    if ([self.navigationBar respondsToSelector:@selector(updateInteractiveTransition:)]) {
        id<LFNavigationBarInteractiveTransition> obj = (id<LFNavigationBarInteractiveTransition>)self.navigationBar;
        [obj updateInteractiveTransition:percentComplete];
    }
}

-(void)renderViewController:(UIViewController *)viewController{
    [self renderViewController:viewController animated:NO];
}
-(void)renderViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

-(void)lf_willTransformToController:(UIViewController *)viewController animated:(BOOL)animated type:(LFNavigationControllerTransformType)type stacks:(NSArray<UIViewController *> *)stacks{
    [((LFNavigationBar *)self.navigationBar) lf_willTransfrom:viewController.navigationItem animated:animated type:type];
}

-(void)lf_didTransformToController:(UIViewController *)viewController animated:(BOOL)animated type:(LFNavigationControllerTransformType)type stacks:(NSArray<UIViewController *> *)stacks{
    [((LFNavigationBar *)self.navigationBar) lf_didTransfrom:viewController.navigationItem animated:animated type:type];
}

-(void)lf_renderViewControllerBar:(UIViewController *)viewController{
    [self lf_renderViewControllerBar:viewController animated:NO];
}

-(void)lf_renderViewControllerBar:(UIViewController *)viewController animated:(BOOL)animated{
    //今天可以10点之前走了[Smart]
    UIViewController *visibleViewController = self.visibleViewController;
    if ([visibleViewController isMemberOfClass:[LFContainerController class]]) {
        visibleViewController = ((LFContainerController *)visibleViewController).customerController;
    }
    if (viewController  == visibleViewController) {
        [self renderViewController:viewController animated:animated];
    }
}

-(Class)lf_navigationBar_Class{
    return [UINavigationBar class];
}

@end
