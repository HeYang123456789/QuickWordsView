//
//  UIWindow+QuickWordsView.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "UIWindow+QuickWordsExtra.h"
#import <objc/runtime.h>


@implementation UIWindow (QuickWordsExtra)
// 等同于在UIWindow这个类中添加了
// @property (nonatomic,retain) QuickWordsView quickWordsView;的set方法和get方法
#pragma mark runtime动态添加QuickWordsView属性
static char QuickWordsView_ExtraObjc;
// get方法
-(QuickWordsView*)quickWordsView{
    return objc_getAssociatedObject(self, &QuickWordsView_ExtraObjc);
}
// set方法
-(void)setQuickWordsView:(QuickWordsView*)quickWordsView{
    objc_setAssociatedObject(self, &QuickWordsView_ExtraObjc, quickWordsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark runtime动态添加qwMaskView属性
// 等同于在UIWindow这个类中添加了
// @property (nonatomic,retain) UIView qwMaskView;的set方法和get方法
static char QuickWordsView_MaskView;
// get方法
-(UIView*)qwMaskView{
    return objc_getAssociatedObject(self, &QuickWordsView_MaskView);
}
// set方法
-(void)setQwMaskView:(UIView*)qwMaskView{
    objc_setAssociatedObject(self, &QuickWordsView_MaskView, qwMaskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark runtime动态添加QuickWordInputView属性
static char QuickWordInputView_ExtraObjc;
// get方法
-(QuickWordInputView*)quickWordInputView{
    return objc_getAssociatedObject(self, &QuickWordInputView_ExtraObjc);
}
// set方法
-(void)setQuickWordInputView:(QuickWordInputView*)quickWordInputView{
    objc_setAssociatedObject(self, &QuickWordInputView_ExtraObjc, quickWordInputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark runtime动态添加inputMaskView属性
static char QuickWordInputView_MaskView;
// get方法
-(UIView*)inputMaskView{
    return objc_getAssociatedObject(self, &QuickWordInputView_MaskView);
}
// set方法
-(void)setInputMaskView:(UIView*)inputMaskView{
    objc_setAssociatedObject(self, &QuickWordInputView_MaskView, inputMaskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
