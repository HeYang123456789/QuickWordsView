//
//  QuickWordsView.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordUtilities.h"


@interface QuickWordsView : UIView

// 尽可能的让对外的接口简单易用
+ (void)showWithSendTextBlock:(void (^)(id objc))bloc;
+ (void)hide;


@end

