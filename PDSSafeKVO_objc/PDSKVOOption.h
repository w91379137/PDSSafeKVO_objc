//
//  PDSKVOOption.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/23.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSafeKVO_objc.h"

#define ModifyIDKey @"ModifyIDKey"

@interface PDSKVOOption : NSObject

//設定接續動作
@property(nonatomic, copy) KVOBlock actionBlock;

//讓xcode會自動跳字
- (void)setActionBlock:(KVOBlock)actionBlock;

/*
 一般的 NSKeyValueObservingOptions 有預設值 
 NSKeyValueObservingOptionsWithoutPrior
 */
@property(nonatomic) NSKeyValueObservingOptions observingOptions;

/*
 辨識符號
 */
@property(nonatomic) void *context;

/*
 存放任何其他你想存放的訊息
 */
@property(nonatomic, strong) NSMutableDictionary *infoDict;

//簡便方法
- (NSMutableDictionary *)nonNullInfoDict;

@end
