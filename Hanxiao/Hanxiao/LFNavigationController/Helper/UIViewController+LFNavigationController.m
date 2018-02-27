//
//  UIViewController+LFNavigationController.m
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import "UIViewController+LFNavigationController.h"
#import "LFRuntime.h"
#import "LFContainerController.h"
#import "UIView+Extend.h"

@implementation UIViewController (LFNavigationController)
@dynamic containerController;


-(void)setContainerController:(LFContainerController *)containerController{
    objc_setAssociatedObject(self, @selector(containerController), containerController,OBJC_ASSOCIATION_ASSIGN);

}

-(LFContainerController *)containerController{
    return objc_getAssociatedObject(self, _cmd);
}

-(UINavigationItem *)lf_navigationItem{
    
    if (self.containerController == nil) {
        return [self lf_navigationItem];
    }
    return [self.containerController navigationItem];
}

+(void)load{
//    [self safe_exchangeInstanceMethod:@selector(lf_navigationItem) to:@selector(navigationItem)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
