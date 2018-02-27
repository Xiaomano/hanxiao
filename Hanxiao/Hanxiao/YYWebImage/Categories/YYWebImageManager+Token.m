//
//  YYWebImageManager+Token.m
//  YYWebImageDemo
//
//  Created by 王虎 on 2017/6/8.
//  Copyright © 2017年 ibireme. All rights reserved.
//

#import "YYWebImageManager+Token.h"

//#import <AliyunOSSiOS/OSSService.h>
//#import <AliyunOSSiOS/OSSCompat.h>

@implementation YYWebImageManager (Token)

//extern OSSClient * client;
//extern NSString  *const bucket;

+ (NSString *)signaturedURLString:(NSString *)originalURL{
    // http://cdn2.blubluapp.com/user%2Favatar%2F58d518e6cb5e557d088dab1a_IMG_20170524_150547_35.png
    NSString *constranURL =  nil;

//    if ([[NullTool judgeNullInstance]stringisViall:originalURL]) {
//    NSString *objectKey = nil;
//    if ([originalURL containsString:@"com/"]) {
//        NSArray *array = [originalURL componentsSeparatedByString:@"com/"];
//        objectKey = array[1];
//    }else{
//        objectKey = originalURL;
//    }
//    OSSTask *task = [client presignConstrainURLWithBucketName:bucket withObjectKey:objectKey withExpirationInterval:60 * 60];
//    if (!task.error) {
//        constranURL = task.result;
//    }else{
//        NSLog(@"error: %@",task.error);
//    }
//    }
    return constranURL;

}

+ (NSURL *)signaturedURL:(NSURL *)originalURL{
    NSString *urlstring = nil;
    if ([originalURL isKindOfClass:[NSString class]]) {
        urlstring = (NSString *)originalURL;
    }else{
        urlstring = [originalURL absoluteString];
    }
    NSString *signaturedURLString = [self signaturedURLString:urlstring];
    return [NSURL URLWithString:signaturedURLString];
}
@end
