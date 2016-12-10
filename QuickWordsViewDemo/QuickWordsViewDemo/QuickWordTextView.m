//
//  QuickWordTextView.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/11.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordTextView.h"


@interface QuickWordTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation QuickWordTextView

// hy: UI placeholder text changed animation duration
CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    // hy:如果不是ARC模式就要手动释放内存
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        _placeholder = @"";
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        _placeholder = @"";
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

// hy:因为这个子Label是实时变化的，随着文字的内容变化而变化的
- (void)drawRect:(CGRect)rect
{
    // hy:因为textView没有placeholder，所以通过继承来拓展这部分组件View
    if( [[self placeholder] length] > 0 )
    {
        UIEdgeInsets insets = self.textContainerInset;
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left+5,insets.top,self.bounds.size.width - (insets.left +insets.right+10),0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.numberOfLines = 40;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [_placeHolderLabel setFrame:CGRectMake(insets.left+5,insets.top,self.bounds.size.width - (insets.left +insets.right+10),CGRectGetHeight(_placeHolderLabel.frame))];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
- (void)setPlaceholder:(NSString *)placeholder{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        // hy:调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect
        [self setNeedsDisplay];
    }
    
}
- (void)_firstBaselineOffsetFromTop
{
}

- (void)_baselineOffsetFromBottom
{
}

@end
