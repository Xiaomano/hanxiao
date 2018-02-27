//
//  LFNavigationPDIT.h
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFNavigationController;

@protocol LFNavigationPDITDelegate <NSObject>

-(void)cancelInteractiveTransition;
-(void)finishInteractiveTransition;
-(void)updateInteractiveTransition:(CGFloat)percentComplete;
-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
@end

@interface LFNavigationPDIT : UIPercentDrivenInteractiveTransition

@property (nonatomic,weak) id<LFNavigationPDITDelegate> delegate;

+(void)hookObject:(id)obj;

@end
