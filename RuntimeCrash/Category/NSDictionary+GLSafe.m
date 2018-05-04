//
//  NSDictionary+GLSafe.m
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "NSDictionary+GLSafe.h"
#import <objc/runtime.h>
#import "NSObject+GLSwizzling.h"
@implementation NSDictionary (GLSafe)
+ (void)load {
    static dispatch_once_t onceToken;
    Class class=objc_getClass("__NSDictionaryI");
    dispatch_once(&onceToken, ^{
        [class swizzleSelector:@selector(initWithObjects:forKeys:count:) withSwizzledSelector:@selector(gl_initWithObjects:forKeys:count:)];
        [class swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:) withSwizzledSelector:@selector(gl_dictionaryWithObjects:forKeys:count:)];
        [self swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:) withSwizzledSelector:@selector(gl_initWithObjects:forKeys:count:)];
        
        [objc_getClass("__NSPlaceholderDictionary") swizzleSelector:@selector(initWithObjects:forKeys:count:) withSwizzledSelector:@selector(gl_initWithObjects:forKeys:count:)];
//        [objc_getClass("__NSPlaceholderDictionary") swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:) withSwizzledSelector:@selector(gl_initWithObjects:forKeys:count:)];
    });
}

+ (instancetype)gl_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)gl_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_initWithObjects:safeObjects forKeys:safeKeys count:j];
}
@end
