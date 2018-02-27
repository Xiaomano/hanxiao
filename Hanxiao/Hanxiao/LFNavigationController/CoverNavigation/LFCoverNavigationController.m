//
//  LFCoverNavigationController.m
//  LFNavigationController2
//
//  Created by 福有李 on 2017/11/22.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import "LFCoverNavigationController.h"
#import "UINavigationItem+AttributeExt.h"
#import "LFCoverNavigationBar.h"
@interface LFCoverNavigationController ()

@end

@implementation LFCoverNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)renderViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [((LFCoverNavigationBar *)self.navigationBar) lf_updateViews:viewController.navigationItem animated:animated];
}

-(void)lf_willTransformToController:(UIViewController *)viewController animated:(BOOL)animated type:(LFNavigationControllerTransformType)type stacks:(NSArray<UIViewController *> *)stacks{
 
    if (stacks.count != 0) {
        stacks.lastObject.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    [super lf_willTransformToController:viewController animated:animated type:type stacks:stacks];
}


//-(void)lf_pushViewControllerAnimated:(UIViewController *)viewController animated:(BOOL)animated{
//    [((LFCoverNavigationBar *)self.navigationBar) lf_navigation_push_item:viewController.navigationItem animated:animated];
//
//}
//-(void)lf_popViewControllerAnimated:(UIViewController *)viewControoler animated:(BOOL)animated{
//    [((LFCoverNavigationBar *)self.navigationBar) lf_navigation_pop_item:viewControoler.navigationItem animated:animated];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(Class)lf_navigationBar_Class{
    return [LFCoverNavigationBar class];
}

@end
