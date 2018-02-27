//
//  UIGestureRecognizer+Target.h
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFRuntime.h"
NSString *NSStringFromObjectAddress(id obj);

@interface UIGestureRecognizer (Target)

@property (nonatomic,readonly) NSArray *allTargets;

@end
