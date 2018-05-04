//
//  NSObject+GLSwizzling.m
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "NSObject+GLSwizzling.h"
#import <objc/runtime.h>
@implementation NSObject (GLSwizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 若已经存在，则添加会失败
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        
                                        method_getImplementation(swizzledMethod),
                                        
                                        method_getTypeEncoding(swizzledMethod));
    
    // 若原来的方法并不存在，则添加即可
    
    if (didAddMethod) {
        
        class_replaceMethod(class,swizzledSelector,
                            
                            method_getImplementation(originalMethod),
                            
                            method_getTypeEncoding(originalMethod));
        
    } else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
