//
//  ThirdViewController.m
//  Hanxiao
//
//  Created by Xiaoxiao_Mac on 2018/2/27.
//  Copyright © 2018年 LinYun. All rights reserved.
//

#import "ThirdViewController.h"
#import "UINavigationItem+AttributeExt.h"
@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第三页";
    self.navigationItem.tintColor = [UIColor redColor];
    self.navigationItem.backgroundColor = [UIColor orangeColor];
    




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
