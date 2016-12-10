//
//  QuickWordUtilities.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#ifndef QuickWordUtilities_h
#define QuickWordUtilities_h

// =====下面的内容，需要在工程中宏定义=====
#import <Masonry.h>
// 边界
#define UIScreenBounds [UIScreen mainScreen].bounds

// 宽度
#define  UIScreenWidth [UIScreen mainScreen].bounds.size.width

// 高度
#define  UIScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScaleFrom_iPhone6_Width(_X_)  (_X_ *  (UIScreenWidth/375))
#define kScaleFrom_iPhone6_Height(_Y_) (_Y_ * (UIScreenHeight/667))


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 深蓝色
#define Color0x04aaff UIColorFromRGB(0x04aaff)

// =========================================


// ========= 配置QuickWordsView的值 =========
#define kQWKeyWindow [UIApplication sharedApplication].keyWindow


// 三块区域：topView：44   centerView：194   bottomView：39
#define Q_TopHeight kScaleFrom_iPhone6_Height(44)
#define Q_CenterHeight kScaleFrom_iPhone6_Height(194)
#define Q_BottomHeight kScaleFrom_iPhone6_Height(39)

// 三块区域之间的灰色线条的高度
#define SpaceLineWidth 2

// QuickWordsView的宽高，高度还要额外+2。
#define QuickWordsView_Width UIScreenWidth
#define QuickWordsView_Height (Q_TopHeight+Q_CenterHeight+Q_BottomHeight+SpaceLineWidth*2)
// QuickWordsView的顶部Y值
#define QuickWordsView_Y (UIScreenHeight-QuickWordsView_Height)

// 中间区域内的Title的左右外边距
#define CenterTitleLRSpace 15
// =========================================

// ========= 配置QuickWordInputView的值 =========
#define QuickWordInputView_X kScaleFrom_iPhone6_Height(20)
#define QuickWordInputView_Width (UIScreenWidth-QuickWordInputView_X*2)
#define QuickWordInputView_Height kScaleFrom_iPhone6_Height(260)
#define QuickWordInputView_Top_Height kScaleFrom_iPhone6_Height(43)
#define QuickWordInputView_Y (UIScreenHeight-QuickWordInputView_Height)*0.5

#define QuickWordInputView_ThemeColor Color0x04aaff

#define QuickWordInputView_TextViewBgColor UIColorFromRGB(0xe9efef)
#define QuickWordInputView_TextColor UIColorFromRGB(0xcecece)

// =============================================

// 枚举状态
typedef NS_ENUM(NSInteger, QuickWordsState)
{
    QuickWordsStateSelection= 0x11,  // 选择状态
    QuickWordsStateDelete    // 删除状态
};

typedef NS_ENUM(NSInteger, QuickWordsReviseState)
{
    QuickWordsReviseStateEdit= 0x11,  // 编辑状态
    QuickWordsReviseStateAdd    // 添加状态
};



#endif /* QuickWordUtilities_h */
