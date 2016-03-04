//
//  PDSSafeKVO_objc.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/5.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#ifndef PDSSafeKVO_objc_h
#define PDSSafeKVO_objc_h

#define weakSelfMake(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define weakMake(object,weakObject) __weak __typeof(&*object)weakObject = object;
#define maybe(object,classType) ((classType *)([object isKindOfClass:[classType class]] ? object : nil))

#include <objc/runtime.h>
#import "NSObject+PDSSafeKVO.h"
#import "NSObject+PDSSafeKVOAction.h"

#endif /* PDSSafeKVO_objc_h */
