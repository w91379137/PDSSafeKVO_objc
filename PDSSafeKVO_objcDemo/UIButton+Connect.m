//
//  UIButton+Connect.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "UIButton+Connect.h"
#import "NSObject+PDSSafeKVO.h"

@implementation UIButton (Connect)

- (void)setDelegate:(UIButton *)delegate
{
    NSArray *keys = @[@"enabled",@"selected",@"highlighted"];
    
    for (NSString *key in keys) {
        [delegate addSafeObserver:self
                       forKeyPath:key
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:NULL];
    }
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
    UIButton *button = (UIButton *)object;
    if (self.enabled != button.enabled) self.enabled = button.enabled;
    if (self.highlighted != button.highlighted) self.highlighted = button.highlighted;
    if (self.selected != button.highlighted ? NO : button.selected) self.selected = button.highlighted ? NO : button.selected;
}

@end
