//
//  TranslationElement.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TranslationElementKey @"TranslationElementKey"

@interface TranslationElement : NSObject
{
    NSArray *translationWords;
    NSArray *periodWords;
}

#pragma mark - Input
- (void)inputString:(NSString *)aString;
- (void)inputFormatString:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
- (void)inputTranslationWords:(NSArray *)translationWords
                  PeriodWords:(NSArray *)periodWords;

#pragma mark - Output
- (NSString *)translationString;

#pragma mark - Format
+ (void)translationWords:(NSArray **)translationWordsPointer
             periodWords:(NSArray **)periodWordsPointer
            sourceString:(NSString *)sourceString;

@end
