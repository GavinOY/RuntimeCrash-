//
//  NSObject+GLSwizzling.h
//  NETestTextField
//
//  Created by N3210 on 2018/5/3.
//  Copyright © 2018年 N3210. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GLSwizzling)
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;
@end
