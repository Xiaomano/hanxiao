//
//  LFRuntime.m
//  LFNavigationController
//
//  Created by 福有李 on 15/12/5.
//  Copyright © 2015年 福有李. All rights reserved.
//

#import "LFRuntime.h"
#import <objc/runtime.h>

static NSString *_currentImageName;

#define THROW_RUNTIME_EXCEPTION(reasonString) {@throw [NSException exceptionWithName:@"LFRuntimeException" reason:reasonString userInfo:nil];}

void class_duplicateIvar(Class fromClass,Class toClass);
void class_duplicateProperty(Class fromClass,Class toClass);
void class_duplicateMethod(Class fromClass,Class toClass);
void class_duplicateProtocol(Class fromClass,Class toClass);


@implementation NSObject (LFRuntime)

+(BOOL)isExistsInstanceMethod:(SEL)sel{
    Method m = class_getInstanceMethod(self, sel);
    return m != nil;
}

+(void)exchangeClassMethod:(SEL)sourceMethod to:(SEL)goalMethod
{
    Method source = class_getClassMethod(self, sourceMethod);
    if (source == nil) THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    Method goal = class_getClassMethod(self, goalMethod);
    if (goal == nil) THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    method_exchangeImplementations(source, goal);
}

+(void)exchangeInstanceMethod:(SEL)sourceMethod to:(SEL)goalMethod
{
    Method source = class_getInstanceMethod(self, sourceMethod);
    if (source == nil) THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    Method goal = class_getInstanceMethod(self, goalMethod);
    if (goal == nil) THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    method_exchangeImplementations(source, goal);
}

+(void)copyInstanceMethod:(SEL)sourceSEL toNewMethod:(SEL)goalSEL{
    Method source = class_getInstanceMethod(self, sourceSEL);
    class_addMethod(self, goalSEL, method_getImplementation(source), method_getTypeEncoding(source));
}

+(void)safe_exchangeInstanceMethod:(SEL)sourceMethod to:(SEL)goalMethod
{
    Method source = [self _safe_getInstanceMethod:sourceMethod];
    if (source == nil) {NSLog(@"打不到要交换的方法 %@",NSStringFromSelector(sourceMethod)); return;}//THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    Method goal = [self _safe_getInstanceMethod:goalMethod];
    if (goal == nil) {NSLog(@"打不到要交换的方法 %@",NSStringFromSelector(goalMethod)); return;}//THROW_RUNTIME_EXCEPTION(@"找不到要交换的方法");
    method_exchangeImplementations(source, goal);
}

+(Method)_safe_getInstanceMethod:(SEL)sel
{
   return [self _safe_getMethod:sel fromClass:[self class]];
}
+(Method)_safe_getClassMethod:(SEL)sel
{
    Class metaClass = objc_getMetaClass([NSStringFromClass([self class]) UTF8String]);
    return [self _safe_getMethod:sel fromClass:metaClass];
}

+(Method)_safe_getMethod:(SEL)sel fromClass:(Class)gclass
{
    NSString *goalName = NSStringFromSelector(sel);
    
    unsigned int count;
    Method *methodList = class_copyMethodList(gclass, &count);
    
    for (int i = 0 ; i < count; i ++) {
        
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        
//        NSLog(@"methodName = %@",methodName);
        
        if ([goalName isEqualToString:methodName]) {
            free(methodList);
            return method;
        }
    }
    free(methodList);
    
    return nil;
}

+(Class)duplicateClass:(Class)superClass newClassName:(NSString *)newClassName
{
    Class newClass = NSClassFromString(newClassName);
    
    if (newClass == nil) {
        
        @synchronized(self) {//thread safe
            
            newClass = NSClassFromString(newClassName);
            
            if (newClass == nil) {
                
                newClass = objc_allocateClassPair(superClass, [newClassName UTF8String], 0/*索引值从0开始*/);
                class_duplicateIvar(self, newClass);
                class_duplicateProperty(self, newClass);
                class_duplicateMethod(self, newClass);
                class_duplicateProtocol(self, newClass);
                objc_registerClassPair(newClass);
            }
        }
    }
    
    return newClass;
}

+(void)load
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    // 执行固件名称
    _currentImageName = [infoDictionary objectForKey:@"CFBundleExecutable"];
}
+(BOOL)isCurrentImageClass
{
//    method_getTypeEncoding(<#Method m#>)

    NSString *className = NSStringFromClass([self class]);
    
    if ([className hasPrefix:@"ST"]) {
        return YES;
    }
    //如果使用动态库， 就这样
//    NSString *imagePath = [NSString stringWithUTF8String:
//                           class_getImageName([self class])];
//    if ([imagePath hasSuffix:_currentImageName]) {
//        return YES;
//    }
//    CFBundleExecutable
    return NO;
}

@end

void class_duplicateIvar(Class fromClass,Class toClass)
{
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList(fromClass, &ivarCount);
    
    ptrdiff_t lastdiff_t = 0;
    for (int i = 0 ; i < ivarCount ; i ++) {
        
        Ivar ivar = ivars[i];
        
        size_t ivar_size = ivar_getOffset(ivar) - lastdiff_t;
        
        class_addIvar(toClass, ivar_getName(ivar), ivar_size, 0/*因为使大小使用的是偏移量，系统已经对齐过了，不需要在对齐了*/,ivar_getTypeEncoding(ivar));
    }
    
    if(ivars != NULL) free(ivars);
}


NSDictionary *lf_property_getAttributes(objc_property_t property)
{
    //分割属性
    NSString *attributesString = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    NSArray *attributes = [attributesString componentsSeparatedByString:@","];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < attributes.count; i ++) {
        
        NSString *attributeString = attributes[i];
        NSString *name = [attributeString substringToIndex:1];
        NSString *value = [attributeString substringFromIndex:1];
        if (nil == value) {
            value = @"";
        }
        [result setObject:value forKey:name];
    }
    
    return result;
}


void class_duplicateProperty(Class fromClass,Class toClass)
{
    unsigned int propertyCount;
    objc_property_t *propertys = class_copyPropertyList(fromClass, &propertyCount);
    
    
    objc_property_attribute_t c_attributes[10];
    
    for (int i = 0; i < propertyCount; i ++) {
        
        objc_property_t property = propertys[i];
        
        const char *propertyName = property_getName(property);
        
        NSDictionary *attributes = lf_property_getAttributes(property);
        
        NSArray *allKey = [attributes allKeys];
        unsigned int attributesCount = (unsigned int)allKey.count;
        
        for (int i = 0;  i < attributesCount; i ++) {
            c_attributes[i].name = [allKey[i] UTF8String];
            c_attributes[i].value = [attributes[allKey[i]] UTF8String];
        }
        
        class_addProperty(toClass, propertyName, c_attributes, attributesCount);
    }
    
    if (propertys != nil) free(propertys);
}


void class_duplicateMethod(Class fromClass,Class toClass)
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList(fromClass, &methodCount);
    
    for (int i = 0; i < methodCount; i ++) {
        
        Method method = methods[i];
        
        class_addMethod(toClass , method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
    }
    
    if (methods != nil) free(methods);
}


void class_duplicateProtocol(Class fromClass,Class toClass)
{
    unsigned int protocolCount;
    
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(fromClass, &protocolCount);
    
    for (int i = 0 ; i < protocolCount; i ++) {
        class_addProtocol(toClass, protocols[i]);
    }
    
    if (protocols != nil) free(protocols);
}

