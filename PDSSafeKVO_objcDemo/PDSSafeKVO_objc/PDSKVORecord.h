//
//  PDSKVORecord.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/23.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"

@class PDSKVOOption;
@interface PDSKVORecord : NSObject

@property(nonatomic, weak) NSObject *sourceObject;
@property(nonatomic, weak) NSObject *observerObject;
@property(nonatomic, strong) NSString *keyPath;
@property(nonatomic) void *context;

@property(nonatomic, strong) PDSKVOOption *options;

- (BOOL)isSameSourceObject:(NSObject *)sourceObject
            ObserverObject:(NSObject *)observerObject
                   KeyPath:(NSString *)keyPath;

- (BOOL)isSameSourceObject:(NSObject *)sourceObject
            ObserverObject:(NSObject *)observerObject
                   KeyPath:(NSString *)keyPath
                   Context:(void *)context;

- (void)removeSafeObserverRecord;

@end
