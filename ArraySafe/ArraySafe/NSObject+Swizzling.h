//
//  NSObject+Swizzling.h
//  ArraySafe
//
//  Created by iStone on 2017/3/10.
//  Copyright © 2017年 iStone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)lx_swizzleMethod:(Class)theClass withOriginalSel:(SEL)originalSelector withSwizzleSel:(SEL)swizzledSelector;

@end
