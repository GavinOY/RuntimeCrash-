//
//  NSMutableArray+GLSafe.m
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import "NSMutableArray+GLSafe.h"
#import "NSObject+GLSwizzling.h"
#import <objc/runtime.h>
@implementation NSMutableArray (GLSafe)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(removeObject:)withSwizzledSelector:@selector(glSafeRemoveObject:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:) withSwizzledSelector:@selector(glSafeAddObject:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:) withSwizzledSelector:@selector(glSafeRemoveObjectAtIndex:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:) withSwizzledSelector:@selector(glSafeInsertObject:atIndex:)];
        [objc_getClass("__NSPlaceholderArray") swizzleSelector:@selector(initWithObjects:count:) withSwizzledSelector:@selector(glSafeInitWithObjects:count:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(glSafeObjectAtIndex:)];
    });
}

- (instancetype)glSafeInitWithObjects:(const id  _Nonnull     __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if ([objects[i] isKindOfClass:[NSArray class]]) {
            NSLog(@"%@", objects[i]);
        }
        if (objects[i] == nil) {
            hasNilObject = YES;
            NSLog(@"%s object at index %lu is nil, it will be     filtered", __FUNCTION__, i);
            
            //#if DEBUG
            //      // 如果可以对数组中为nil的元素信息打印出来，增加更容    易读懂的日志信息，这对于我们改bug就好定位多了
            //      NSString *errorMsg = [NSString     stringWithFormat:@"数组元素不能为nil，其index为: %lu", i];
            //      NSAssert(objects[i] != nil, errorMsg);
            //#endif
        }
    }
    
    // 因为有值为nil的元素，那么我们可以过滤掉值为nil的元素
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        return [self glSafeInitWithObjects:newObjects count:index];
    }
    return [self glSafeInitWithObjects:objects count:cnt];
}

- (void)glSafeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
    } else {
        [self glSafeAddObject:obj];
    }
}
- (void)glSafeRemoveObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s call -removeObject:, but argument obj is nil", __FUNCTION__);
        return;
    }
    [self glSafeRemoveObject:obj];
}

- (void)glSafeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
    } else if (index > self.count) {
        NSLog(@"%s index is invalid", __FUNCTION__);
    } else {
        [self glSafeInsertObject:anObject atIndex:index];
    }
}

- (id)glSafeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    if (index >= self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    return [self glSafeObjectAtIndex:index];
}

- (void)glSafeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return;
    }
    if (index >= self.count) {
        NSLog(@"%s index out of bound", __FUNCTION__);
        return;
    }
    [self glSafeRemoveObjectAtIndex:index];
}
@end
