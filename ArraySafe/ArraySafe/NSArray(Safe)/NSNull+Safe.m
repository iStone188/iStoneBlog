//
//  NSNull+Safe.m
//  ArraySafe
//
//  Created by iStone on 2017/3/10.
//  Copyright © 2017年 iStone. All rights reserved.
//

#import "NSNull+Safe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSNull (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self lx_swizzleMethod:[NSNull class] withOriginalSel:@selector(methodSignatureForSelector:) withSwizzleSel:@selector(lx_methodSignatureForSelector:)];
        [self lx_swizzleMethod:[NSNull class] withOriginalSel:@selector(forwardInvocation:) withSwizzleSel:@selector(lx_forwardInvocation:)];
    });
}

- (NSMethodSignature *)lx_methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = [self lx_methodSignatureForSelector:sel];
    if (signature) {
        return signature;
    }
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)lx_forwardInvocation:(NSInvocation *)invocation {
    NSInteger returnLength = [[invocation methodSignature] methodReturnLength];
    if (!returnLength) {
        return;
    }
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    [invocation setReturnValue:buffer];
}

@end
