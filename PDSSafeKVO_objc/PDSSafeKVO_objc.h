//
//  PDSSafeKVO_objc.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/5.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#ifndef PDSSafeKVO_objc_h
#define PDSSafeKVO_objc_h

#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#import "PDSSetting.h"

typedef void (^KVOBlock)(NSString *keyPath, id object, NSDictionary *change, void *context);

#import "PDSKVOOption.h"
#import "PDSKVORecord.h"

#import "NSObject+PDSSafeKVO.h"

#endif /* PDSSafeKVO_objc_h */
