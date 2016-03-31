//
//  LanguageCenter.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "LanguageCenter.h"
#import "CHCSVParser.h"

static NSString *codeKey = @"code";

@interface LanguageCenter()
{
    CHCSVParser *parser;
    NSMutableArray *array;
}
@end

@implementation LanguageCenter

#pragma mark - Init
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //下載網址https://docs.google.com/spreadsheets/d/1zF-6m_e3m8AmzCQ2xyYokIds5I4qsu7to4mQ_vJu_TY/edit?usp=sharing
        
        NSURL *url =
        [[NSBundle mainBundle] URLForResource:@"多國語言 - 工作表1" withExtension:@"csv"];
        parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:url];
        array = [[NSArray arrayWithContentsOfDelimitedURL:url
                                                  options:CHCSVParserOptionsUsesFirstLineAsKeys | CHCSVParserOptionsRecognizesComments
                                                delimiter:','
                                                    error:nil] mutableCopy];
        
    }
    return self;
}

#pragma mark - Translation
+ (NSString *)translationOfString:(NSString *)string
{
    LanguageCenter *center = [LanguageCenter sharedInstance];
    return [center translateStringForLocKey:string
                               languageCode:center.currentLanguageCode];
}

+ (NSString *)translationOfString:(NSString *)string LanguageCode:(NSString *)languageCode
{
    LanguageCenter *center = [LanguageCenter sharedInstance];
    return [center translateStringForLocKey:string
                               languageCode:languageCode];
}

- (NSString *)translateStringForLocKey:(NSString *)locKey
                          languageCode:(NSString *)languageCode
{
    if (locKey.length == 0) {
        return @"";
    }
    
    NSString *complete = nil;
    
    //特殊版本
    if ([locKey rangeOfString:@"#"].length > 0) {
        complete = [self searchTranslateOfKey:locKey
                                 languageCode:languageCode];
        
        //去除符號
        {
            NSArray *split = [locKey componentsSeparatedByString:@"#"];
            locKey = split.firstObject;
        }
        
        //去除符號
        if (complete) {
            NSArray *split = [complete componentsSeparatedByString:@"#"];
            complete = split.firstObject;
        }
    }
    
    if (!complete) {
        complete = [self searchTranslateOfKey:locKey
                                 languageCode:languageCode];
    }
    
    if (complete) {
        return complete;
    }
    
    return NSLocalizedString(locKey,nil);
}

- (NSString *)searchTranslateOfKey:(NSString *)key
                      languageCode:(NSString *)languageCode
{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"%K == %@",codeKey,key];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] > 0) {
        if ([filteredArray count] > 1) NSLog(@"%@ has many translation",key);
        
        NSString *translatedString = filteredArray.lastObject[languageCode];
        if (!translatedString || translatedString.length == 0) {
            //NSLog(@"%@ was not translated to %@",key, languageCode);
            return nil;
        }
        return translatedString;
    }
    return nil;
}


@end
