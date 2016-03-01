//
//  UILabel+AutoTitle.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "UILabel+AutoTitle.h"
static char listenKeyChar;
#include <objc/runtime.h>
#import "NSObject+PDSSafeKVO.h"

@implementation UILabel (AutoTitle)

#pragma mark - Setter / Getter
- (void)setListenKey:(NSString *)key
{
    objc_setAssociatedObject (self, &listenKeyChar, key, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)listenKey
{
    return (NSString *)objc_getAssociatedObject(self, &listenKeyChar);
}

- (void)setDelegate:(UIButton *)delegate
{
    [delegate addSafeObserver:self
                   forKeyPath:self.listenKey
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:NULL];
}

- (UIButton *)delegate
{
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    self.text = [object valueForKey:keyPath];
}

@end
