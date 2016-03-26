//
//  PDSSetting.h
//  PDSSetting_objcDemo
//
//  Created by w91379137 on 2016/3/26.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#ifndef PDSSetting_h
#define PDSSetting_h

#define weakSelfMake(weakSelf) __weak __typeof(self)weakSelf = self;
#define weakMake(object,weakObject) __weak __typeof(object)weakObject = object;

#define maybe(object,classType) ((classType *)([object isKindOfClass:[classType class]] ? object : nil))
#define maybeDefault(object, classType, default) ((classType *)([object isKindOfClass:[classType class]] ? object : default))

#endif /* PDSSetting_h */
