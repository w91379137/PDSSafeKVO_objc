//
//  LanguageCenter.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageCenter : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSString *currentLanguageCode;

+ (NSString *)translationOfString:(NSString *)string;
+ (NSString *)translationOfString:(NSString *)string LanguageCode:(NSString *)languageCode;

@end
