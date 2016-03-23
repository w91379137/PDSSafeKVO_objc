//
//  PDSKVOOption.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/23.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"

typedef void (^KVOBlock)(NSString *keyPath, id object, NSDictionary *change, void *context);
#define ModifyIDKey @"ModifyIDKey"

@interface PDSKVOOption : NSObject

@property(nonatomic, copy) KVOBlock actionBlock;
- (void)setActionBlock:(KVOBlock)actionBlock;//讓xcode會自動跳字

@property(nonatomic) NSKeyValueObservingOptions observingOptions;
@property(nonatomic) void *context;

@property(nonatomic, strong) NSMutableDictionary *infoDict;
- (NSMutableDictionary *)nonNullInfoDict;

@end
