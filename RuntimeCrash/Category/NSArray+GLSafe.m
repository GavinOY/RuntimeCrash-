//
//  NSArray+GLSafe.m
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "NSArray+GLSafe.h"
#import <objc/runtime.h>
#import "NSObject+GLSwizzling.h"
@implementation NSArray (GLSafe)
+(void)load{
    static dispatch_once_t onceToken;
    Class class = objc_getClass("__NSArrayI");
    dispatch_once(&onceToken, ^{
        [class swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(glSafeObjectAtIndex:)];
    });
}

- (void)glSafeObjectAtIndex:(NSUInteger)index {
    if (index >=self.count) {
        @try {
            return[self glSafeObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"-------- %s Crash Because Method %s -------\n",class_getName(self.class),__func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {
            
        }
    }else {
        return [self glSafeObjectAtIndex:index];
    }
}
@end
