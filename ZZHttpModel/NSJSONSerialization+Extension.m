//
//  NSJSONSerialization+Extension.m
//  YZHttpModel
//
//  Created by yun on 16/9/7.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "NSJSONSerialization+Extension.h"
#import <objc/runtime.h>

@implementation NSJSONSerialization (Extension)

//替换对象方法
+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getInstanceMethod([self class], origSelector);
    Method method2 = class_getInstanceMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}
//替换类方法
+ (void)swizzleClassSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getClassMethod([self class], origSelector);
    Method method2 = class_getClassMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}

+(void)load {
    [self swizzleClassSelector:@selector(JSONObjectWithData:options:error:) withNewSelector:@selector(myJSONObjectWithData:options:error:)];
}

+ (nullable id)myJSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id object = [self myJSONObjectWithData:data options:opt error:error];
    if (object) {
        return object;
    }
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    data = [text dataUsingEncoding:NSUTF8StringEncoding];
    object = [self myJSONObjectWithData:data options:opt error:error];
    if (object) {
        return object;
    }
    
    return data;
//    text = [text stringByReplacingOccurrencesOfString:@"," withString:@",\""];
    
}
@end
