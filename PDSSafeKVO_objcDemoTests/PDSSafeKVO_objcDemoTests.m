//
//  PDSSafeKVO_objcDemoTests.m
//  PDSSafeKVO_objcDemoTests
//
//  Created by w91379137 on 2016/4/5.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDSSafeKVO_objc.h"
#import "TestPropertyObject.h"

@interface PDSSafeKVO_objcDemoTests : XCTestCase

@end

@implementation PDSSafeKVO_objcDemoTests

#pragma mark - Init
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Example
- (void)testExample
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - testKVO
- (void)testKVO
{
    NSMutableArray *keepArray = [NSMutableArray array];
    
    NSLog(@"start A 聽 A");
    {//A 聽 A
        TestPropertyObject *a = [[TestPropertyObject alloc] init];
        [keepArray addObject:a];
        
        weakMake(a, objectA);
        [a addSafeObserver:a
                forKeyPath:NSStringFromSelector(@selector(aString))
            UniqueModifyID:[NSString stringWithFormat:@"%s",__func__]
               ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                   
                   NSAssert(object == objectA, @"object 不相同");
                   NSAssert([keyPath isEqualToString:NSStringFromSelector(@selector(aString))], @"keyPath 不相同");
                   
                   objectA.otherString = objectA.aString;
               }];
        
        {//測試連動效果
            a.aString = @"123";
            NSAssert([a.aString isEqualToString:a.otherString], @"value 不相同");
        }
        {//A 釋放
            [keepArray removeObject:a];
        }
    }
    NSLog(@"end A 聽 A");
    [keepArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTestPropertyObjectCrashKey
                                                        object:nil];
    
    NSLog(@"start A 聽 B");
    {//A 聽 B
        {//A 先放
            NSArray *objects = [self arrayAObserverB:keepArray];
            [keepArray removeObject:objects.firstObject];
        }
        {//B 先放
            NSArray *objects = [self arrayAObserverB:keepArray];
            [keepArray removeObject:objects.lastObject];
        }
    }
    NSLog(@"end A 聽 B");
    [keepArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTestPropertyObjectCrashKey
                                                        object:nil];
    
    NSLog(@"start A B 互聽");
    {//A B 互聽
        {//A 先放
            NSArray *objects = [self arrayABLink:keepArray];
            [keepArray removeObject:objects.firstObject];
        }
        {//B 先放
            NSArray *objects = [self arrayABLink:keepArray];
            [keepArray removeObject:objects.lastObject];
        }
    }
    NSLog(@"end A B 互聽");
    [keepArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTestPropertyObjectCrashKey
                                                        object:nil];
}

- (NSArray *)arrayAObserverB:(NSMutableArray *)keepArray
{
    NSMutableArray *abArray = [NSMutableArray array];
    
    TestPropertyObject *a = [[TestPropertyObject alloc] init];
    [keepArray addObject:a];
    [abArray addObject:a];
    
    TestPropertyObject *b = [[TestPropertyObject alloc] init];
    [keepArray addObject:b];
    [abArray addObject:b];
    
    weakMake(a, objectA);
    weakMake(b, objectB);
    [b addSafeObserver:a
            forKeyPath:NSStringFromSelector(@selector(aString))
        UniqueModifyID:[NSString stringWithFormat:@"%s",__func__]
           ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
               
               NSAssert(object == objectB, @"object 不相同");
               NSAssert([keyPath isEqualToString:NSStringFromSelector(@selector(aString))], @"keyPath 不相同");
               
               objectA.aString = objectB.aString;
           }];
    
    {//測試連動效果
        b.aString = @"123";
        NSAssert([a.aString isEqualToString:b.aString], @"value 不相同");
    }
    
    return abArray;
}

- (NSArray *)arrayABLink:(NSMutableArray *)keepArray
{
    NSMutableArray *abArray = [NSMutableArray array];
    
    TestPropertyObject *a = [[TestPropertyObject alloc] init];
    [keepArray addObject:a];
    [abArray addObject:a];
    
    TestPropertyObject *b = [[TestPropertyObject alloc] init];
    [keepArray addObject:b];
    [abArray addObject:b];
    
    weakMake(a, objectA);
    weakMake(b, objectB);
    [b addSafeObserver:a
            forKeyPath:NSStringFromSelector(@selector(aString))
        UniqueModifyID:[NSString stringWithFormat:@"%s",__func__]
           ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
               
               NSAssert(object == objectB, @"object 不相同");
               NSAssert([keyPath isEqualToString:NSStringFromSelector(@selector(aString))], @"keyPath 不相同");
               
               if (![objectA.aString isEqualToString:objectB.aString])
                   objectA.aString = objectB.aString;
           }];
    
    [a addSafeObserver:b
            forKeyPath:NSStringFromSelector(@selector(aString))
        UniqueModifyID:[NSString stringWithFormat:@"%s",__func__]
           ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
               
               NSAssert(object == objectA, @"object 不相同");
               NSAssert([keyPath isEqualToString:NSStringFromSelector(@selector(aString))], @"keyPath 不相同");
               
               if (![objectB.aString isEqualToString:objectA.aString])
                   objectB.aString = objectA.aString;
           }];
    
    {//測試連動效果
        b.aString = @"123";
        NSAssert([a.aString isEqualToString:b.aString], @"value 不相同");
        
        a.aString = @"123";
        NSAssert([a.aString isEqualToString:b.aString], @"value 不相同");
    }
    
    return abArray;
}

@end
