//
//  NSObject+PDSSafeKVOAction.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/4.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^KVOBlock)(NSString *keyPath, id object, NSDictionary *change, void *context);

@interface NSObject (PDSSafeKVOAction)

@property(nonatomic, strong) NSMutableDictionary *actionDict;

- (void)addSafeKVOObject:(NSObject *)object
              SourcePath:(NSString *)sourcePath
                ModifyID:(NSString *)modifyID
             ActionBlock:(KVOBlock)actionBlock;

@end
