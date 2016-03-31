//
//  TranslationElement.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "TranslationElement.h"
#import "LanguageCenter.h"

@implementation TranslationElement

#pragma mark - Input
- (void)inputString:(NSString *)aString
{
    NSArray *aTranslationWords;
    NSArray *aPeriodWords;
    
    [TranslationElement translationWords:&aTranslationWords
                             periodWords:&aPeriodWords
                            sourceString:aString];
    
    [self inputTranslationWords:aTranslationWords
                    PeriodWords:aPeriodWords];
}

- (void)inputFormatString:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2)
{
    NSMutableArray *translationWordsx = [NSMutableArray array];
    NSArray *periodWordsx = [format componentsSeparatedByString:@"%@"];
    NSArray *testArray = [format componentsSeparatedByString:@"%"];
    if (testArray.count != periodWordsx.count) {
        NSLog(@"error format");
        return;
    }
    
    va_list argList;
    if (format)
    {
        va_start(argList, format);
        NSString *arg;
        for (NSInteger k = 0; k < periodWords.count - 1; k++) {
            arg = va_arg(argList, id);
            if ([arg isKindOfClass:[NSString class]]) {
                [translationWordsx addObject:arg];
            }
            else {
                [translationWordsx addObject:arg.description];
            }
        }
        va_end(argList);
    }
    [self inputTranslationWords:translationWordsx
                    PeriodWords:periodWordsx];
}

- (void)inputTranslationWords:(NSArray *)aTranslationWords
                  PeriodWords:(NSArray *)aPeriodWords
{
    translationWords = aTranslationWords;
    periodWords = aPeriodWords;
}

#pragma mark - Output
- (NSString *)translationString
{
    NSMutableString *string = [NSMutableString string];
    
    for (NSInteger k = 0; k < translationWords.count || k < periodWords.count; k++) {
        
        if (k < periodWords.count) {
            [string appendString:periodWords[k]];
        }
        
        if (k < translationWords.count) {
            if ([LanguageCenter sharedInstance].currentLanguageCode) {
                [string appendString:[LanguageCenter translationOfString:translationWords[k]]];
            }
            else {
                [string appendString:@"$"];
                [string appendString:translationWords[k]];
                [string appendString:@"$"];
            }
        }
    }
    return string;
}

#pragma mark - Format
+ (void)translationWords:(NSArray **)translationWordsPointer
             periodWords:(NSArray **)periodWordsPointer
            sourceString:(NSString *)sourceString
{
    if ([sourceString rangeOfString:@"$"].length > 0) {
        NSArray *comp = [sourceString componentsSeparatedByString:@"$"];
        
        NSMutableArray *aTranslationWords = [NSMutableArray array];
        NSMutableArray *aPeriodWords = [NSMutableArray array];
        
        for (int i = 0; i < comp.count; i++) {
            if (i % 2 == 0) {
                [aPeriodWords addObject:comp[i]];
            }
            else {
                [aTranslationWords addObject:comp[i]];
            }
        }
        *translationWordsPointer = aTranslationWords;
        *periodWordsPointer = aPeriodWords;
    }
    else {
        
        if (sourceString) {
            *translationWordsPointer = @[sourceString];
        }
        else {
            *translationWordsPointer = @[];
        }
        
        *periodWordsPointer = @[];
    }
}

@end
