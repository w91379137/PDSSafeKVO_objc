//
//  PDSKVORecord.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/23.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSKVORecord.h"

@implementation PDSKVORecord

- (BOOL)isSameSourceObject:(NSObject *)sourceObject
            ObserverObject:(NSObject *)observerObject
                   KeyPath:(NSString *)keyPath
{
    //在 Dealloc 時 其中一個會消失
    if (self.sourceObject)
        if (sourceObject != self.sourceObject) return NO;
    if (self.observerObject)
        if (observerObject != self.observerObject) return NO;
    if (![keyPath isEqualToString:self.keyPath]) return NO;
    return YES;
}

- (BOOL)isSameSourceObject:(NSObject *)sourceObject
            ObserverObject:(NSObject *)observerObject
                   KeyPath:(NSString *)keyPath
                   Context:(void *)context
{
    if (![self isSameSourceObject:sourceObject
                  ObserverObject:observerObject
                          KeyPath:keyPath]) return NO;
    if (context != self.context) return NO;
    return YES;
}

- (void)removeSafeObserverRecord
{
    [self.sourceObject removeSafeObserver:self.observerObject
                               forKeyPath:self.keyPath
                                  context:self.context];
}

//- (void)dealloc
//{
//    NSLog(@"dealloc %@",NSStringFromClass([self class]));
//}

@end
