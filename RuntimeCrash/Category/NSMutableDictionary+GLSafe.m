//
//  NSMutableDictionary+GLSafe.m
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "NSMutableDictionary+GLSafe.h"
#import "NSObject+GLSwizzling.h"
#import <objc/runtime.h>
@implementation NSMutableDictionary (GLSafe)
+ (void)load {
    static dispatch_once_t onceToken;
    Class class = objc_getClass("__NSDictionaryM");
    dispatch_once(&onceToken, ^{
        [class swizzleSelector:@selector(setObject:forKey:) withSwizzledSelector:@selector(glSafeSetObject:forKey:)];
    });
}

- (void)glSafeSetObject:(id)object forKey:(NSString *)key {
    if (object == nil) {
        @try {
            [self glSafeSetObject:object forKey:key];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            object = [NSString stringWithFormat:@""];
            [self glSafeSetObject:object forKey:key];
        }
        @finally {}
    }else {
        [self glSafeSetObject:object forKey:key];
    }
}
@end
