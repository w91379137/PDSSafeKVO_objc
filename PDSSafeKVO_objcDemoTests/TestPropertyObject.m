//
//  TestPropertyObject.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/5.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "TestPropertyObject.h"

@implementation TestPropertyObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ifExistAndCrash)
                                                     name:kTestPropertyObjectCrashKey
                                                   object:nil];
    }
    return self;
}

- (void)ifExistAndCrash
{
    NSAssert(NO, @"ifExistAndCrash");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kTestPropertyObjectCrashKey
                                                  object:nil];
    NSLog(@"%s",__func__);
}

@end
