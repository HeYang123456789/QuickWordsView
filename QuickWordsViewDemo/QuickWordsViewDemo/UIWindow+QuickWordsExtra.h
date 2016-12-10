//
//  UIWindow+QuickWordsExtra.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordsView.h"
#import "QuickWordInputView.h"

@interface UIWindow (QuickWordsExtra)

#pragma mark - 类别拓展 QuickWordsView需要的属性
@property (nonatomic,retain) QuickWordsView *quickWordsView;
@property (nonatomic,retain) UIView *qwMaskView;


#pragma mark - 类别拓展 QuickWordInputView 需要的属性
@property (nonatomic,retain) QuickWordInputView *quickWordInputView;
@property (nonatomic,retain) UIView *inputMaskView;


@end
