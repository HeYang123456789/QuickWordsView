//
//  QuickWordInputView.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordUtilities.h"

@protocol QuickWordInputViewDelegate;

@interface QuickWordInputView : UIView

@property (nonatomic,strong) id<QuickWordInputViewDelegate> delegate;

+ (instancetype)getQuickWordsInputView;
- (void)showWithText:(NSString*)text;
- (void)show;
- (void)hide;

@end

@protocol QuickWordInputViewDelegate <NSObject>

- (void)clickedSaveBtn:(QuickWordInputView*)inputView
              saveText:(NSString*)text;
- (void)clickedSendBtn:(QuickWordInputView*)inputView
              sendText:(NSString*)text;

@end
