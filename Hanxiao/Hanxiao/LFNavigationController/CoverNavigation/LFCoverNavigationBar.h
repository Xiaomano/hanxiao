//
//  LFCoverNavigationBar.h
//  LFNavigationController2
//
//  Created by 福有李 on 2017/11/22.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFNavigationBar.h"
@interface LFCoverNavigationBar : LFNavigationBar

//-(void)lf_transfrom_item:(UINavigationItem *)item to:(UINavigationItem *)item
-(void)lf_sync_item:(UINavigationItem *)item animated:(BOOL)animated;

@end
