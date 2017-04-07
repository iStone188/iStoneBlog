//
//  AppDelegate.m
//  ArraySafe
//
//  Created by iStone on 2017/3/10.
//  Copyright © 2017年 iStone. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    id nilObj  = nil;
    
#pragma mark - 测试NSArray
    NSArray *array = @[@"aa", nilObj];
    NSLog(@"llllarray: %@", array);
    
    NSArray *testArr = [NSArray arrayWithObjects:@"123",nilObj, nil];
    NSLog(@"测试nil=%@", testArr);
    
    NSArray *abcArr = [[NSArray alloc] initWithObjects:@"456", @"23",nilObj, nil];
    NSLog(@"火红的nil=%@", abcArr);
    
    NSString *ddddd = [abcArr objectAtIndex:2];
    NSLog(@"测试索引地址=%@", ddddd);
    
    
    NSMutableArray *testMutableArr = [[NSMutableArray alloc] initWithCapacity:3];
    [testMutableArr insertObject:@"222" atIndex:0];
    [testMutableArr insertObject:nilObj atIndex:10];
    
    [testMutableArr removeObjectAtIndex:1];
    
    [testMutableArr replaceObjectAtIndex:0 withObject:nilObj];
    
    [testMutableArr addObject:@"333"];
    
    [testMutableArr addObject:nilObj];
    
    NSLog(@"测试的数组为=%@", testMutableArr);
    
    
#pragma mark - 测试Null
    NSString *nilObject = (NSString *)[NSNull null];
    
    NSLog(@"null:%lu", (unsigned long)[nilObject length]);
    
#pragma mark - 测试NSDictionary
    NSDictionary *dict = @{@"aKey" : nilObj, @"bKey" : @"bb"};  //dictionarywith
    NSLog(@"当前的dict=%@", dict);
    
    NSDictionary *initDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"bbb", @"bbKey",nilObj,@"aaKey", nil];
    NSLog(@"当前的initDict=%@", initDict);
    
    NSMutableDictionary *testMutDict = [[NSMutableDictionary alloc] init];
    [testMutDict setObject:nilObj forKey:@"hello"];
    NSLog(@"当前的testMutDict=%@", testMutDict);
    
    NSDictionary *nilDict = @{@"kkk" : @"123"};
    
    [testMutDict addEntriesFromDictionary:nilDict];
    NSLog(@"当前的testMutDict2=%@", testMutDict);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
