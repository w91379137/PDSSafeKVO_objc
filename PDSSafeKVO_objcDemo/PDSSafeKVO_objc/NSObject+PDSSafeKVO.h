//
//  NSObject+PDSSafeKVO.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSKeyValueObservingOptionsWithoutPrior NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 

@interface NSObject (PDSSafeKVO)

@property (nonatomic, strong) NSMutableArray *safeObserverArray;

- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context;

- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(void *)context;

- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

@end
