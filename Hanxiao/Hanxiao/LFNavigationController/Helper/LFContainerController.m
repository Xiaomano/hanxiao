//
//  LFContainerController.m
//  BluChat
//
//  Created by 福有李 on 2017/11/7.
//  Copyright © 2017年 Bluchat. All rights reserved.
//

#import "LFContainerController.h"
#import "LFNavigationController.h"
#import "UIViewController+LFNavigationController.h"
#import "LFRuntime.h"
#import "UINavigationItem+AttributeExt.h"

@interface LFContainerController ()
{
    BOOL _isAppear;
}
@end

@implementation LFContainerController

-(void)setCustomerController:(UIViewController *)customerController{
    if (customerController == nil) {
        _customerController.containerController = nil;
        _customerController = nil;
    }else{
        _customerController = customerController;
        _customerController.containerController = self;
        self.navigationItem.owner = customerController;
//        self.navigationItem = _customerController.navigationItem;
    }
}

-(UINavigationItem *)navigationItem{
    if (_customerController == nil) {
        return [super navigationItem];
    }
    return _customerController.navigationItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self stepCustomerView];
    
}

-(void)stepCustomerView{
    if (self.customerController != nil) {
        if (_isAppear) {
            [self.customerController beginAppearanceTransition:YES animated:YES];
        }
        [self addChildViewController:self.customerController];
        
        self.customerController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.customerController.view];
        UIView *view = self.customerController.view;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
        
        if (_isAppear) {
            [self.customerController endAppearanceTransition];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    LFNavigationController *navigationController = [self targetForAction:@selector(lf_change_navigation_status_from_controller:) withSender:nil];
//    if (navigationController != nil) {
//        [navigationController lf_change_navigation_status_from_controller:self];
//    }
//}

-(void)viewDidAppear:(BOOL)animated{
    _isAppear = YES;
   
    [super viewDidAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated{
    _isAppear = NO;
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"容器释放");
    self.customerController = nil;
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
