//
//  NSObject+PDSSafeKVO.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"
#import "NSObject+PDSSafeKVO.h"

@implementation NSObject (Weak)

WeakReference MakeWeakReference (id object)
{
    __weak id weakref = object;
    return ^{ return weakref; };
}

id WeakReferenceNonretainedObjectValue (WeakReference ref)
{
    if (ref == nil)
        return nil;
    else
        return ref ();
}

@end

static char kSafeObserverArray;

#define kOtherObj   @"OtherObj"
#define kKeyPath    @"keyPath"
#define kAction     @"action"
#define kPartner    @"partner"

#define kIsSelfObserver @"IsSelfObserver"

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

#pragma mark - Add Remove
- (void)addSafeObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context
{
    [self removeSafeObserver:observer
                  forKeyPath:keyPath];
    
    NSMutableDictionary *selfKVODict = [NSMutableDictionary dictionary];
    [selfKVODict setObject:MakeWeakReference(observer) forKey:kOtherObj];
    [selfKVODict setObject:keyPath forKey:kKeyPath];
    [selfKVODict setObject:@(NO) forKey:kIsSelfObserver];//被觀察者
    [self.nonnullSafeObserverArray addObject:selfKVODict];
    
    NSMutableDictionary *otherKVODict = [NSMutableDictionary dictionary];
    [otherKVODict setObject: MakeWeakReference(self) forKey:kOtherObj];
    [otherKVODict setObject:keyPath forKey:kKeyPath];
    [otherKVODict setObject:@(YES) forKey:kIsSelfObserver];
    [observer.nonnullSafeObserverArray addObject:otherKVODict];//觀察者
    
    [selfKVODict setObject:MakeWeakReference(otherKVODict) forKey:kPartner];
    [otherKVODict setObject:MakeWeakReference(selfKVODict) forKey:kPartner];
    
    /*
    if (self.safeObserverArray.count > 10) {
        NSLog(@"selfKVODict %@ %lu",NSStringFromClass([self class]) ,(unsigned long)self.safeObserverArray.count);
    }
     */
    
    [self addObserver:observer
           forKeyPath:keyPath
              options:options
              context:context];
}

- (void)removeSafeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
{
    NSDictionary *sameSelfDict =
    [self sameObject:observer
             KeyPath:keyPath
      IsSelfObserver:NO];
    
    NSDictionary *sameOtherDict =
    [observer sameObject:self
                 KeyPath:keyPath
          IsSelfObserver:YES];
    
    if (sameSelfDict || sameOtherDict) {
        
        /*
        if (sameSelfDict == nil || sameOtherDict == nil) {
            NSLog(@"%@",sameSelfDict);
            NSLog(@"%@",self.safeObserverArray);
            NSLog(@"%lu",(unsigned long)self.hash);
            
            NSLog(@"%@",sameOtherDict);
            NSLog(@"%@",observer.safeObserverArray);
            NSLog(@"%lu",(unsigned long)observer.hash);
        }
         */
        
        [self.safeObserverArray removeObject:sameSelfDict];
        [self.safeObserverArray removeObject:WeakReferenceNonretainedObjectValue(sameOtherDict[kPartner])];
        
        [observer.safeObserverArray removeObject:sameOtherDict];
        [observer.safeObserverArray removeObject:WeakReferenceNonretainedObjectValue(sameSelfDict[kPartner])];
        
        @try{
            [self removeObserver:observer
                      forKeyPath:keyPath];
        } @catch(id anException) {}
    }
    else {
        //NSLog(@"該物件並無 註冊此方法");
    }
}

- (NSDictionary *)sameObject:(NSObject *)other
                     KeyPath:(NSString *)keyPath
              IsSelfObserver:(BOOL)isSelfObserver
{
    NSDictionary *sameDict = nil;
    for (NSDictionary *checkDict in self.safeObserverArray) {
        if ([checkDict[kIsSelfObserver] boolValue] == isSelfObserver) {
            NSObject *obj = WeakReferenceNonretainedObjectValue(checkDict[kOtherObj]);
            if (obj == other) {
                NSString *keyPathx = checkDict[kKeyPath];
                if ([keyPathx isEqualToString:keyPath]) {
                    sameDict = checkDict;
                    break;
                }
            }
        }
    }
    return sameDict;
}

#pragma mark - Work
- (void)fullDealloc
{
    [self safeDeallocRelease];
    [self fullDealloc];
}

- (void)safeDeallocRelease
{
    NSMutableArray *copyToRun = [self.safeObserverArray mutableCopy];
    
    for (NSDictionary *info in copyToRun) {
        
        BOOL isSelfObserver = [info[kIsSelfObserver] boolValue];
        
        NSObject *objObserver = nil;
        NSObject *objRemoveObserver = nil;
        
        if (isSelfObserver) {
            objObserver = self;
            objRemoveObserver = WeakReferenceNonretainedObjectValue(info[kOtherObj]);
        }
        else {
            objObserver = WeakReferenceNonretainedObjectValue(info[kOtherObj]);
            objRemoveObserver = self;
        }
        
        if (objObserver && objRemoveObserver) {//若其中一方不存在 則 不進行
            @try {
                [objRemoveObserver removeSafeObserver:objObserver
                                           forKeyPath:info[kKeyPath]];
            }
            @catch (NSException *exception) {}
        }
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
