//
//  QuickWordsModels.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QuickWordsModelsMutArr_Key @"QuickWordsModelsMutArr_Key"

@interface QuickWordsModels : NSObject

// 获取快捷语
+ (NSArray*)getQuickWordsArr;
// 获取对应index的字符串
+ (NSString*)getQuickWordIndex:(NSInteger)index;
// 添加快捷语
+ (NSArray*)addQuickWord:(NSString*)word;
// 编辑某一句快捷语，并替换
+ (NSArray*)editQuickWord:(NSString*)word index:(NSInteger)index;
// 删除快捷语
+ (NSArray*)deleteQuickWordsInIndex:(NSInteger)index;
// 是否有快捷语
+ (BOOL)isHasWord;

@end
