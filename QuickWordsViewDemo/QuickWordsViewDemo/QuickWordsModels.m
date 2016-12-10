//
//  QuickWordsModels.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordsModels.h"

@implementation QuickWordsModels

#pragma mark - Public

+ (NSArray*)getQuickWordsArr{
    NSArray *wordsArr = [[NSUserDefaults standardUserDefaults] objectForKey:QuickWordsModelsMutArr_Key];
    return wordsArr;
}

+ (NSString*)getQuickWordIndex:(NSInteger)index{
    // 先从本地序列化中取出 QuickWordsModelsMutArr_Key
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    NSInteger wordsCount = wordsArr.count;
    NSString* word = nil;
    if (index < 0 || index >= wordsCount) {
        word = nil;
    }else if ([QuickWordsModels isHasWordWithArr:wordsArr]) {
        word = (NSString*)wordsArr[index];
    }
    return word;
}

// 采用本地化存储来处理 添加
+ (NSArray*)addQuickWord:(NSString*)word{
    NSMutableArray *wordsMutArr;
    // 先从本地序列化中取出 QuickWordsModelsMutArr_Key
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    if ([QuickWordsModels isHasWordWithArr:wordsArr]) {
        wordsMutArr = [NSMutableArray arrayWithArray:wordsArr];
    }else{
        wordsMutArr = [NSMutableArray array];
    }
    [wordsMutArr addObject:word];
    // 存回本地中去
    NSArray *newWordsArr = wordsMutArr.copy;
    [QuickWordsModels saveQuickWords:newWordsArr];
    
    return newWordsArr;
}
// 采用本地化存储来处理 修改
+ (NSArray*)editQuickWord:(NSString*)word index:(NSInteger)index{
    NSMutableArray *wordsMutArr;
    // 先从本地序列化中取出 QuickWordsModelsMutArr_Key
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    if ([QuickWordsModels isHasWordWithArr:wordsArr]) {
        wordsMutArr = [NSMutableArray arrayWithArray:wordsArr];
    }else{
        wordsMutArr = [NSMutableArray array];
    }
    // 修改对应index的字符串
    NSString *indexStr = (NSString*)[wordsMutArr objectAtIndex:index];
    if ([indexStr isEqualToString:word]) {
        return wordsArr;
    }
    // 替换
    [wordsMutArr replaceObjectAtIndex:index withObject:word];
    
    // 存回本地中去
    NSArray *newWordsArr = wordsMutArr.copy;
    [QuickWordsModels saveQuickWords:newWordsArr];
    return newWordsArr;
}

+ (NSArray*)deleteQuickWordsInIndex:(NSInteger)index{
    NSMutableArray *wordsMutArr;
    // 先从本地序列化中取出 QuickWordsModelsMutArr_Key
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    if ([QuickWordsModels isHasWordWithArr:wordsArr]) {
        wordsMutArr = [NSMutableArray arrayWithArray:wordsArr];
    }else{
        wordsMutArr = [NSMutableArray array];
    }
    NSInteger allCount = wordsMutArr.count;
    if (index >= allCount || index < 0) {
        [QuickWordsModels saveQuickWords:wordsMutArr.copy];
        return wordsMutArr.copy;
    }else{
        [wordsMutArr removeObjectAtIndex:index];
        [QuickWordsModels saveQuickWords:wordsMutArr.copy];
        return wordsMutArr.copy;
    }
}

+ (BOOL)isHasWord{
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    return [QuickWordsModels isHasWordWithArr:wordsArr];
}


#pragma mark - Private
+ (BOOL)isHasWordWithArr:(NSArray*)array{
    if (array && array.count>0) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)saveQuickWords:(NSArray*)wordsArr{
    [[NSUserDefaults standardUserDefaults] setObject:wordsArr
                                              forKey:QuickWordsModelsMutArr_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
