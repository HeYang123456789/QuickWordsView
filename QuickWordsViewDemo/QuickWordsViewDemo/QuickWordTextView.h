//
//  QuickWordTextView.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/11.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickWordTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
