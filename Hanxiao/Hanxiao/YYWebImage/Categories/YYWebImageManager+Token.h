//
//  YYWebImageManager+Token.h
//  YYWebImageDemo
//
//  Created by 王虎 on 2017/6/8.
//  Copyright © 2017年 ibireme. All rights reserved.
//

#import "YYWebImageManager.h"

@interface YYWebImageManager (Token)

+ (NSURL *)signaturedURL:(NSURL *)originalURL;

@end
