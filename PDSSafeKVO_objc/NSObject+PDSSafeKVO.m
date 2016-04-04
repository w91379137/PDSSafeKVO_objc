//
//  NSObject+PDSSafeKVO.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "NSObject+PDSSafeKVO.h"

static char kSafeObserverArray;

@implementation NSObject (PDSSafeKVO)

#pragma mark - Setter / Getter
-(void)setSafeObserverArray:(NSMutableArray *)safeObserverArray
{
    objc_setAssociatedObject (self, &kSafeObserverArray, safeObserverArray, OBJC_ASSOCIATION_RETAIN);
}

-(NSMutableArray *)safeObserverArray
{
    return (NSMutableArray *)objc_getAssociatedObject(self, &kSafeObserverArray);
}

-(NSMutableArray *)nonnullSafeObserverArray
{
    NSMutableArray *array = (NSMutableArray *)objc_getAssociatedObject(self, &kSafeObserverArray);
    if (![array isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray array];
        self.safeObserverArray = array;
    }
    return array;
}

#pragma mark - Add / Remove

#pragma mark - v0
- (void)addObserver:(NSObject *)observer
             Record:(PDSKVORecord *)record
{
    [self.nonnullSafeObserverArray addObject:record];
    if (self != observer) //self KVO self
        [observer.nonnullSafeObserverArray addObject:record];
}

#pragma mark - v1
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context
{
    PDSKVORecord *record = [[PDSKVORecord alloc] init];
    record.sourceObject = self;
    record.observerObject = observer;
    record.keyPath = keyPath;
    record.context = context;
    
    [self addObserver:observer
               Record:record];
    
    [self addObserver:observer
           forKeyPath:keyPath
              options:options
              context:context];
}

/*
 PDSKVORecord 其中一指標已經消失 故 無法完全在 PDSKVORecord 實作
 */
- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(void *)context
{
    PDSKVORecord *findRecord = nil;
    
    for (PDSKVORecord *record in self.safeObserverArray) {
        
        if ([record isSameSourceObject:self
                        ObserverObject:observer
                               KeyPath:keyPath
                               Context:context]) {
            findRecord = record;
            break;
        }
    }
    for (PDSKVORecord *record in observer.safeObserverArray) {
        
        if ([record isSameSourceObject:self
                        ObserverObject:observer
                               KeyPath:keyPath
                               Context:context]) {
            findRecord = record;
            break;
        }
    }
    
    if (findRecord) {
        
        [self.safeObserverArray removeObject:findRecord];
        [observer.safeObserverArray removeObject:findRecord];
        
        @try{
            [self removeObserver:observer
                      forKeyPath:keyPath
                         context:findRecord.context];
        } @catch(id anException) {}
    }
    else {
        //NSLog(@"該物件並無 註冊此方法");
    }
}

/*
 PDSKVORecord 其中一指標已經消失 故 無法完全在 PDSKVORecord 實作
 */
- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
{
    NSMutableArray *findRecords = [NSMutableArray array];
    
    for (PDSKVORecord *record in self.safeObserverArray) {
        
        if ([record isSameSourceObject:self
                        ObserverObject:observer
                               KeyPath:keyPath]) {
            [findRecords addObject:record];
        }
    }
    for (PDSKVORecord *record in observer.safeObserverArray) {
        
        if ([record isSameSourceObject:self
                        ObserverObject:observer
                               KeyPath:keyPath]) {
            [findRecords addObject:record];
        }
    }
    
    if (findRecords.count > 0) {
        
        [self.safeObserverArray removeObjectsInArray:findRecords];
        [observer.safeObserverArray removeObjectsInArray:findRecords];
        
        @try{
            [self removeObserver:observer
                      forKeyPath:keyPath];
        } @catch(id anException) {}
    }
    else {
        //NSLog(@"該物件並無 註冊此方法");
    }
}

#pragma mark - v2
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
          PDSKVOOptions:(PDSKVOOption *)kvoOption
{
    kvoOption = maybeDefault(kvoOption, PDSKVOOption, [[PDSKVOOption alloc] init]);
    
    PDSKVORecord *record = [[PDSKVORecord alloc] init];
    record.sourceObject = self;
    record.observerObject = observer;
    record.keyPath = keyPath;
    record.context = kvoOption.context;
    record.options = kvoOption;
    
    [self addObserver:observer
               Record:record];
    
    [self addObserver:observer
           forKeyPath:keyPath
              options:kvoOption.observingOptions
              context:kvoOption.context];
}

#pragma mark - v2 convenience
- (NSArray<PDSKVORecord *> *)findSameModifyID:(NSString *)modifyID
{
    modifyID = maybe(modifyID, NSString);
    if (!modifyID) return @[];
    
    NSMutableArray *findRecord = [NSMutableArray array];
    
    for (PDSKVORecord *record in self.safeObserverArray) {
        if (record.observerObject == self &&
            [record.options.infoDict[ModifyIDKey] isEqualToString:modifyID]) {
            [findRecord addObject:record];
        }
    }
    
    return findRecord;
}

- (void)removeSafeObserverWithModifyID:(NSString *)modifyID
{
    NSArray *findRecord = [self findSameModifyID:modifyID];
    for (PDSKVORecord *record in findRecord) {
        [record removeSafeObserverRecord];
    }
}

- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
         UniqueModifyID:(NSString *)uniqueModifyID
            ActionBlock:(KVOBlock)actionBlock
{
    PDSKVOOption *option = [[PDSKVOOption alloc] init];
    
    uniqueModifyID = maybe(uniqueModifyID, NSString);
    if (uniqueModifyID) {
        
        //observer 排除有相同修改效力的kvo 例如 像是其他修改text 就需要移除
        [observer removeSafeObserverWithModifyID:uniqueModifyID];
        [option.nonNullInfoDict setObject:uniqueModifyID
                                   forKey:ModifyIDKey];
    }
    
    option.actionBlock = actionBlock;
    
    [self addSafeObserver:observer
               forKeyPath:keyPath
            PDSKVOOptions:option];
}

#pragma mark - observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    BOOL isAction = NO;
    for (PDSKVORecord *record in self.safeObserverArray) {
        
        if (object == record.sourceObject &&
            [keyPath isEqualToString:record.keyPath]) {
            
            PDSKVOOption *options = record.options;
            
            if (options.actionBlock &&
                options.context == context) {
                
                options.actionBlock(keyPath,object,change,context);
                isAction = YES;
            }
        }
    }
    
    if (!isAction) {
        Class superTest = [self superclass];
        if (superTest) {
            [superTest observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - Dealloc work
- (void)fullDealloc
{
    if (self.safeObserverArray) [self safeDeallocRelease]; //防止沒有 KVO 物件無限loop
    [self fullDealloc];
}

- (void)safeDeallocRelease
{
    NSMutableArray *copyToRun = [self.safeObserverArray mutableCopy];
    for (PDSKVORecord *record in copyToRun) {
        
        NSObject *sourceObject =
        maybeDefault(record.sourceObject, NSObject, self);
        
        NSObject *observerObject =
        maybeDefault(record.observerObject, NSObject, self);
        
        [sourceObject removeSafeObserver:observerObject
                              forKeyPath:record.keyPath
                                 context:record.context];
    }
}

//http://nshipster.com/method-swizzling/
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(fullDealloc);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

@end
