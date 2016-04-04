//
//  TestPropertyObject.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/5.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTestPropertyObjectCrashKey @"TestPropertyObjectCrashKey"

@interface TestPropertyObject : NSObject

@property(nonatomic, strong) NSString *aString;
@property(nonatomic, strong) NSString *otherString;

@end
