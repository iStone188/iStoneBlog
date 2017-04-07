//
//  NSArray+Safe.m
//  iStoneWork
//
//  Created by iStone on 2017/3/9.
//  Copyright © 2017年 RaytheonTechnology. All rights reserved.
//

#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self lx_swizzleMethod:objc_getClass("__NSArrayI") withOriginalSel:@selector(objectAtIndex:) withSwizzleSel:@selector(lx_objectAtIndex:)];
        [self lx_swizzleMethod:objc_getClass("__NSSingleObjectArrayI") withOriginalSel:@selector(objectAtIndex:) withSwizzleSel:@selector(lx_objectAtIndex:)];
        [self lx_swizzleMethod:objc_getClass("__NSArrayI") withOriginalSel:@selector(arrayWithObjects:count:) withSwizzleSel:@selector(lx_arrayWithObjects:count:)];
        [self lx_swizzleMethod:objc_getClass("__NSPlaceholderArray") withOriginalSel:@selector(initWithObjects:count:) withSwizzleSel:@selector(lx_initWithObjects:count:)];
    });
}

- (id)lx_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSLog(@"lx_objectAtIndex:%lu count:%lu", (unsigned long)index, self.count);
        return nil;
    }
    return [self lx_objectAtIndex:index];
    
}

+ (instancetype)lx_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    id nObjects[cnt];
    int safeCnt = 0;
    for (int i=0; i<cnt; i++) {
        if (objects[i]) {
            nObjects[safeCnt] = objects[i];
            safeCnt++;
        }
    }
    return [self lx_arrayWithObjects:nObjects count:safeCnt];
}

- (instancetype)lx_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    id nObjects[cnt];
    int safeCnt = 0;
    for (int i=0; i<cnt; i++) {
        if (objects[i]) {
            nObjects[safeCnt] = objects[i];
            safeCnt++;
        }
    }
    return [self lx_initWithObjects:nObjects count:safeCnt];
}

@end

@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayClass = objc_getClass("__NSArrayM");
        [self lx_swizzleMethod:arrayClass withOriginalSel:@selector(addObject:) withSwizzleSel:@selector(lx_addObject:)];
        [self lx_swizzleMethod:arrayClass withOriginalSel:@selector(insertObject:atIndex:) withSwizzleSel:@selector(lx_insertObject:atIndex:)];
        [self lx_swizzleMethod:arrayClass withOriginalSel:@selector(removeObjectAtIndex:) withSwizzleSel:@selector(lx_removeObjectAtIndex:)];
        [self lx_swizzleMethod:arrayClass withOriginalSel:@selector(replaceObjectAtIndex:withObject:) withSwizzleSel:@selector(lx_replaceObjectAtIndex:withObject:)];
    });
}

- (void)lx_addObject:(id)anObject {
    if (!anObject) {
        NSLog(@"lx_addObject:%@", anObject);
        return;
    }
    [self lx_addObject:anObject];
}

- (void)lx_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        NSLog(@"lx_insertObject:%lu anObject:%@", (unsigned long)index, anObject);
        return;
    }
    [self lx_insertObject:anObject atIndex:index];
}

- (void)lx_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSLog(@"lx_removeObjectAtIndex:%lu", (unsigned long)index);
        return;
    }
    [self lx_removeObjectAtIndex:index];
}

- (void)lx_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject || (index >= self.count)) {
        NSLog(@"lx_replaceObjectAtIndex:%lu anObject:%@", (unsigned long)index, anObject);
        return;
    }
    [self lx_replaceObjectAtIndex:index withObject:anObject];
}

@end
