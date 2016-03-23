//
//  NSObject+PDSSafeKVO.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"

#define NSKeyValueObservingOptionsWithoutPrior NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 

@class PDSKVORecord;
@interface NSObject (PDSSafeKVO)

@property (nonatomic, strong) NSMutableArray *safeObserverArray;

#pragma mark - v1
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context;

- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(void *)context;

- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

#pragma mark - v2
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
          PDSKVOOptions:(PDSKVOOption *)kvoOption;

- (NSArray<PDSKVORecord *> *)findSameModifyID:(NSString *)modifyID;
- (void)removeSafeObserverWithModifyID:(NSString *)modifyID;

@end
