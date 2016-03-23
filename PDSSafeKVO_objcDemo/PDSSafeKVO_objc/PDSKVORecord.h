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

/*
 被聽取者
 */
@property(nonatomic, weak) NSObject *sourceObject;

/*
 聽取者
 */
@property(nonatomic, weak) NSObject *observerObject;

/*
 聽取路徑
 */
@property(nonatomic, strong) NSString *keyPath;

/*
 辨識符號
 */
@property(nonatomic) void *context;

/*
 特殊設定
 */
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
