//
//  NSObject+Swizzling.m
//  ArraySafe
//
//  Created by iStone on 2017/3/10.
//  Copyright © 2017年 iStone. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)lx_swizzleMethod:(Class)theClass withOriginalSel:(SEL)originalSelector withSwizzleSel:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    class_addMethod(theClass, originalSelector, class_getMethodImplementation(theClass, originalSelector), method_getTypeEncoding(originalMethod));
    class_addMethod(theClass, swizzledSelector, class_getMethodImplementation(theClass, swizzledSelector), method_getTypeEncoding(swizzledMethod));
    method_exchangeImplementations(class_getInstanceMethod(theClass, originalSelector), class_getInstanceMethod(theClass, swizzledSelector));
}

@end
