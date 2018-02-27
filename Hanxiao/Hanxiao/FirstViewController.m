//
//  FirstViewController.m
//  Hanxiao
//
//  Created by Xiaoxiao_Mac on 2018/2/27.
//  Copyright © 2018年 LinYun. All rights reserved.
//

#import "FirstViewController.h"
#import "UINavigationItem+AttributeExt.h"
#import "ThirdViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加好友";
    self.navigationItem.tintColor = [UIColor blueColor];

    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrButton setImage:[UIImage imageNamed:@"iconQrcode的副本"] forState:UIButtonTypeCustom];
    [qrButton addTarget:self action:@selector(qrButtonClickedHandler) forControlEvents:UIControlEventTouchUpInside];
    [qrButton sizeToFit];
    qrButton.frame = CGRectMake(328, 33, 27,27);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:qrButton];

}
-(void)qrButtonClickedHandler{

    NSLog(@"点击二维码 二维码");

    ThirdViewController *third =  [[ThirdViewController alloc]init];
    [self.navigationController pushViewController:third animated:YES];
    

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
