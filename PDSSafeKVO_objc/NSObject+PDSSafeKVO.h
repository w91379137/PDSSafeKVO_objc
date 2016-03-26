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
/*
 增加會自動解除的KVO
 */
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context;

/*
 解除一個KVO
 */
- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(void *)context;

/*
 解除多個KVO
 */
- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

#pragma mark - v2
/*
 增加會自動解除的KVO 附帶特殊設定 詳見 PDSKVOOption
 */
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
          PDSKVOOptions:(PDSKVOOption *)kvoOption;

#pragma mark - v2 convenience
- (NSArray<PDSKVORecord *> *)findSameModifyID:(NSString *)modifyID;

- (void)removeSafeObserverWithModifyID:(NSString *)modifyID;

- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
         UniqueModifyID:(NSString *)uniqueModifyID
            ActionBlock:(KVOBlock)actionBlock;

@end
