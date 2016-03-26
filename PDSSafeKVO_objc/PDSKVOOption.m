//
//  PDSKVOOption.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/23.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSKVOOption.h"

@implementation PDSKVOOption

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observingOptions = NSKeyValueObservingOptionsWithoutPrior;
        weakSelfMake(weakSelf);
        _context = &weakSelf;
    }
    return self;
}

- (NSMutableDictionary *)nonNullInfoDict
{
    if (!self.infoDict) {
        self.infoDict = [NSMutableDictionary dictionary];
    }
    return self.infoDict;
}

//- (void)dealloc
//{
//    NSLog(@"dealloc %@",NSStringFromClass([self class]));
//}

@end
