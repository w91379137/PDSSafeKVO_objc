//
//  UILabel+Language.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "UILabel+Language.h"
#import "LanguageCenter.h"
#import "TranslationElement.h"

@implementation UILabel (Language)

- (void)setLocalText:(NSString *)localText
{
#if TARGET_INTERFACE_BUILDER
    self.text = localText;
#else
    PDSKVOOption *kvoOption = [[PDSKVOOption alloc] init];
    
    {//排除相同text修改
        NSString *modifyID = NSStringFromSelector(@selector(text));
        [kvoOption.nonNullInfoDict setObject:modifyID
                                      forKey:ModifyIDKey];
        [self removeSafeObserverWithModifyID:modifyID];
    }
    
    //儲存紀錄
    TranslationElement *element = [[TranslationElement alloc] init];
    [element inputString:localText];
    [kvoOption.nonNullInfoDict setObject:element
                                  forKey:TranslationElementKey];
    
    {//設定動作
        weakSelfMake(weakSelf);
        weakMake(element, weakElement);
        
        [kvoOption setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
            weakSelf.text = weakElement.translationString;
        }];
    }
    
    [[LanguageCenter sharedInstance] addSafeObserver:self
                                          forKeyPath:NSStringFromSelector(@selector(currentLanguageCode))
                                       PDSKVOOptions:kvoOption];
#endif
}

- (NSString *)localText
{
    return nil;
}

@end
