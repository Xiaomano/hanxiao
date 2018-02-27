//
//  LFRuntime.h
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

Class class_joinNewClass(Class superClass,Class proxyClass);

@interface NSObject (LFRuntime)
+(void)exchangeClassMethod:(SEL)sourceMethod to:(SEL)goalMethod;
+(void)exchangeInstanceMethod:(SEL)sourceMethod to:(SEL)goalMethod;

+(BOOL)isExistsInstanceMethod:(SEL)sel;

+(void)copyInstanceMethod:(SEL)sourceSEL toNewMethod:(SEL)goalSEL;

+(Class)duplicateClass:(Class)superClass newClassName:(NSString *)newClassName;
+(void)safe_exchangeInstanceMethod:(SEL)sourceMethod to:(SEL)goalMethod;
+(BOOL)isCurrentImageClass;
@end
