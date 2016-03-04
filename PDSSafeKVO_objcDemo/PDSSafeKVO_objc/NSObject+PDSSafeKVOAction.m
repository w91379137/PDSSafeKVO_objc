//
//  NSObject+listen.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/4.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"
#import "NSObject+PDSSafeKVOAction.h"

static NSString *actionDictKey = @"actionDictKey";

#define kActionBlockKey @"ActionBlockKey"
#define kActionPathKey  @"ActionPathKey"

@implementation NSObject (PDSSafeKVOAction)

#pragma mark - Setter / Getter
- (void)setActionDict:(NSMutableDictionary *)actionDict
{
    [self willChangeValueForKey:@"actionDict"];
    objc_setAssociatedObject (self, &actionDictKey, actionDict, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"actionDict"];
}

- (NSMutableDictionary *)actionDict
{
    id obj = objc_getAssociatedObject(self,&actionDictKey);
    return obj;
}

- (NSMutableDictionary *)nonnullActionDict
{
    NSMutableDictionary *dict = self.actionDict;
    if (![dict isKindOfClass:[NSMutableDictionary class]]) {
        dict = [NSMutableDictionary dictionary];
        self.actionDict = dict;
    }
    return dict;
}

#pragma mark -
- (void)addSafeKVOObject:(NSObject *)object
              SourcePath:(NSString *)sourcePath
                ModifyID:(NSString *)modifyID
             ActionBlock:(KVOBlock)actionBlock
{
    [self.nonnullActionDict setObject:@{kActionPathKey : sourcePath,
                                        kActionBlockKey : actionBlock}
                               forKey:modifyID];
    
    [object addSafeObserver:self
                 forKeyPath:sourcePath
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:NULL];
}

#pragma mark - observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    BOOL isAction = NO;
    for (NSString *modifyID in self.actionDict.allKeys) {
        
        NSDictionary *actionDict = self.actionDict[modifyID];
        
        if ([actionDict[kActionPathKey] isEqualToString:keyPath]) {
            isAction = YES;
            
            void (^actionBlock) (NSString *keyPath, id object, NSDictionary *change, void *context) =
            actionDict[kActionBlockKey];
            actionBlock(keyPath,object,change,context);
        }
    }
    
    if (!isAction) {
        Class superTest = [self superclass];
        if (superTest) {
            [superTest observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

@end
