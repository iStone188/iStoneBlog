//
//  NSDictionary+Safe.m
//  ArraySafe
//
//  Created by iStone on 2017/3/10.
//  Copyright © 2017年 iStone. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self lx_swizzleMethod:objc_getClass("__NSPlaceholderDictionary") withOriginalSel:@selector(initWithObjects:forKeys:count:) withSwizzleSel:@selector(lx_initWithObjects:forKeys:count:)];
        [self lx_swizzleMethod:objc_getClass("__NSDictionaryI") withOriginalSel:@selector(dictionaryWithObjects:forKeys:count:) withSwizzleSel:@selector(lx_dictionaryWithObjects:forKeys:count:)];
    });
}

- (instancetype)lx_initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeIndex = 0;
    for (NSUInteger i=0; i<cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[safeIndex] = key;
        safeObjects[safeIndex] = obj;
        safeIndex++;
    }
    return [self lx_initWithObjects:safeObjects forKeys:safeKeys count:safeIndex];
}

+ (instancetype)lx_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeIndex = 0;
    for (NSUInteger i=0; i<cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[safeIndex] = key;
        safeObjects[safeIndex] = obj;
        safeIndex++;
    }
    return [self lx_dictionaryWithObjects:safeObjects forKeys:safeKeys count:safeIndex];
}

@end

@implementation NSMutableDictionary (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self lx_swizzleMethod:objc_getClass("__NSDictionaryM") withOriginalSel:@selector(setObject:forKey:) withSwizzleSel:@selector(lx_setObject:forKey:)];
        [self lx_swizzleMethod:objc_getClass("__NSDictionaryM") withOriginalSel:@selector(setObject:forKeyedSubscript:) withSwizzleSel:@selector(lx_setObject:forKeyedSubscript:)];
    });
}

- (void)lx_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    if (!anObject) {
        anObject = [NSNull null];
    }
    [self lx_setObject:anObject forKey:aKey];
}

- (void)lx_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    if (!obj) {
        obj = [NSNull null];
    }
    [self lx_setObject:obj forKeyedSubscript:key];
}

@end


