//
//  QuickWordInputView.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordInputView.h"
#import "QuickWordTextView.h"
#import "UIWindow+QuickWordsExtra.h"



@interface QuickWordInputView ()

@property (nonatomic,assign) CGFloat qwi_Width;
@property (nonatomic,assign) CGFloat qwi_Height;
@property (nonatomic,assign) CGFloat qwi_X;
@property (nonatomic,assign) CGFloat qwi_Y;
@property (nonatomic,assign) CGFloat qwi_TopHeight;

@property (nonatomic,assign) CGFloat qwi_CancelBtn_X;
@property (nonatomic,assign) CGFloat qwi_One_Btn_Width;

@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) QuickWordTextView *textView;

//限制输入字数
@property (nonatomic,assign) long limitNum;

@end

@implementation QuickWordInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _qwi_X = QuickWordInputView_X;
        _qwi_Width = QuickWordInputView_Width;
        _qwi_Height = QuickWordInputView_Height;
        _qwi_TopHeight = QuickWordInputView_Top_Height;
        _qwi_Y = QuickWordInputView_Y;
        
        _qwi_CancelBtn_X = _qwi_Width - _qwi_TopHeight;
        _qwi_One_Btn_Width = (_qwi_Width - kScaleFrom_iPhone6_Width(49))*0.5;
        
        _limitNum = 20;
    }
    return self;
}


+ (instancetype)getQuickWordsInputView{
    QuickWordInputView *inputView = [QuickWordInputView new];
    inputView.frame = CGRectMake(inputView.qwi_X, inputView.qwi_Y, inputView.qwi_Width, inputView.qwi_Height);
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.alpha = 0;// 开始是透明的
    inputView.layer.masksToBounds = YES;
    inputView.layer.cornerRadius = 8;
    
    // 创建顶部View
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, inputView.qwi_Width, inputView.qwi_TopHeight);
    topView.backgroundColor = QuickWordInputView_ThemeColor;
    [inputView addSubview:topView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"快捷回复";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.center = topView.center;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(inputView.qwi_CancelBtn_X, 0, inputView.qwi_TopHeight, inputView.qwi_TopHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:inputView action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    // 创建中间TextView
    QuickWordTextView *textView = [QuickWordTextView new];
    textView.backgroundColor = QuickWordInputView_TextViewBgColor;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 6;
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholder = @"输入您的常用回复，请不要填写QQ、微信等联系方式或广告信息，否则系统将封禁您的账号";
    textView.placeholderColor = QuickWordInputView_TextColor;
    [inputView addSubview:textView];
    inputView.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).equalTo(@(kScaleFrom_iPhone6_Height(17)));
        make.left.equalTo(@(kScaleFrom_iPhone6_Width(17)));
        make.right.equalTo(@(kScaleFrom_iPhone6_Width(-17)));
        make.height.equalTo(@(kScaleFrom_iPhone6_Height(100)));
    }];
    
    // 创建UITextView的右下角的数字提示Label
    UILabel *numberLabel = [UILabel new];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [inputView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).equalTo(@12);
        make.right.equalTo(textView);
    }];
    inputView.numberLabel = numberLabel;
    
    
    // 创建两个按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = QuickWordInputView_ThemeColor;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6;
    [saveBtn addTarget:inputView action:@selector(clickedSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(17));
        make.bottom.equalTo(@(-23));
        make.height.equalTo(@(35));
        make.width.equalTo(@(inputView.qwi_One_Btn_Width));
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = QuickWordInputView_ThemeColor;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 6;
    [sendBtn addTarget:inputView action:@selector(clickedSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-17));
        make.bottom.equalTo(@(-23));
        make.height.equalTo(@(35));
        make.width.equalTo(@(inputView.qwi_One_Btn_Width));
    }];
    
    [inputView addNotification];
    
    return inputView;
}

- (void)showWithText:(NSString*)text{
    
    if (!kQWKeyWindow.quickWordInputView) {
        // 创建蒙板
        UIView *maskView = [UIView new];
        maskView.frame = UIScreenBounds;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;// 开始是透明的
        [kQWKeyWindow addSubview:maskView];
        kQWKeyWindow.inputMaskView = maskView;
        
        self.textView.text = text;
        [kQWKeyWindow addSubview:self];
        kQWKeyWindow.quickWordInputView = self;
        
        // 设置富文本
        NSInteger textLength = text.length;
        NSInteger lengthStrLength = [NSString stringWithFormat:@"%ld",textLength].length;
        NSString *showText = [NSString stringWithFormat:@"%ld/%ld",textLength,_limitNum];
        NSMutableAttributedString *attributedString = [self setAttributedString:showText textColor:QuickWordInputView_ThemeColor range:NSMakeRange(0, lengthStrLength)];
        self.numberLabel.attributedText = attributedString;
        
        
        // 给蒙板添加手势 类方法注意Target参数传的是这个类，不是对象
        UITapGestureRecognizer *tapSheet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [maskView addGestureRecognizer:tapSheet];
        
        [UIView animateWithDuration:0.2 animations:^{
            maskView.alpha  = 0.4;
            self.alpha = 1;
        }];
    }
    [self.textView becomeFirstResponder];
}

- (void)show{
    if (!kQWKeyWindow.quickWordInputView) {
        // 创建蒙板
        UIView *maskView = [UIView new];
        maskView.frame = UIScreenBounds;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;// 开始是透明的
        [kQWKeyWindow addSubview:maskView];
        kQWKeyWindow.inputMaskView = maskView;
        
        [kQWKeyWindow addSubview:self];
        kQWKeyWindow.quickWordInputView = self;
        
        // 设置富文本
        NSString *text = @"0";
        NSInteger textLength = text.length;
        NSInteger lengthStrLength = [NSString stringWithFormat:@"%ld",textLength].length;
        NSString *showText = [NSString stringWithFormat:@"%ld/%ld",textLength,_limitNum];
        NSMutableAttributedString *attributedString = [self setAttributedString:showText textColor:QuickWordInputView_ThemeColor range:NSMakeRange(0, lengthStrLength)];
        self.numberLabel.attributedText = attributedString;
        
        // 给蒙板添加手势 类方法注意Target参数传的是这个类，不是对象
        UITapGestureRecognizer *tapSheet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [maskView addGestureRecognizer:tapSheet];
    
        [UIView animateWithDuration:0.2 animations:^{
            maskView.alpha  = 0.4;
            self.alpha = 1;
        }];
    }
    [self.textView becomeFirstResponder];
}

- (void)hide{
    if (kQWKeyWindow.quickWordInputView) {
        [_textView resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
            kQWKeyWindow.inputMaskView.alpha = 0;
        } completion:^(BOOL finished) {
            [kQWKeyWindow.quickWordInputView removeFromSuperview];
            [kQWKeyWindow.inputMaskView removeFromSuperview];
            kQWKeyWindow.inputMaskView = nil;
            kQWKeyWindow.quickWordInputView = nil;
        }];
    }
}
- (void)clickedSaveBtn:(UIButton*)sender{
    if ([_textView.text isEqualToString:@""]) {
        [QuickWordInputView showNotInputText:@"您还没有输入哦"];
    }else if(_textView.text.length > _limitNum){
        NSString *limitNumStr = [NSString stringWithFormat:@"最多只能输入%ld字哦",_limitNum];
        [QuickWordInputView showNotInputText:limitNumStr];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(clickedSaveBtn:saveText:)]) {
            [_delegate clickedSaveBtn:self saveText:_textView.text];
        }
        [self hide];
    }
}
- (void)clickedSendBtn:(UIButton*)sender{
    if ([_textView.text isEqualToString:@""]) {
        [QuickWordInputView showNotInputText:@"您还没有输入哦"];
    }else if(_textView.text.length > _limitNum){
        NSString *limitNumStr = [NSString stringWithFormat:@"最多只能输入%ld字哦",_limitNum];
        [QuickWordInputView showNotInputText:limitNumStr];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(clickedSendBtn:sendText:)]) {
            [_delegate clickedSendBtn:self sendText:_textView.text];
        }
        [self hide];
    }
}

// 弹出提示@"您还没有输入哦"
+ (void)showNotInputText:(NSString*)text{
    UILabel *notInputLabel = [UILabel new];
    CGFloat labelHeight = 46;
    notInputLabel.frame = CGRectMake(0, 0, 300, labelHeight);
    notInputLabel.layer.masksToBounds = YES;
    notInputLabel.layer.cornerRadius = labelHeight*0.5;
    notInputLabel.text = text;
    notInputLabel.textAlignment = NSTextAlignmentCenter;
    notInputLabel.textColor = [UIColor whiteColor];
    notInputLabel.backgroundColor = [UIColor colorWithRed:0.137 green:0.137 blue:0.137 alpha:0.8];
    [kQWKeyWindow addSubview:notInputLabel];
    notInputLabel.center = kQWKeyWindow.center;
    [UIView animateWithDuration:2 animations:^{
        notInputLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [notInputLabel setHidden:YES];
        [notInputLabel removeFromSuperview];
    }];
}

- (void)addNotification{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(onKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(onKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    
    // 使用通知监听文字改变
    [center addObserver:self
               selector:@selector(textDidChange:)
                   name:UITextViewTextDidChangeNotification
                 object:self.textView];
}

- (void)onKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    NSLog(@"\n开始位置%@\n结束位置%@",NSStringFromCGRect([userInfoDic[UIKeyboardFrameBeginUserInfoKey] CGRectValue]),
          NSStringFromCGRect([userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue]));
    NSLog(@"弹出的动画时间间隔%lf",[userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    NSLog(@"弹出的时间曲线%ld",[userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]);
    
    // ============================================================
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardRect            = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight         = MIN(CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
    
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight+self.qwi_Y);
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    NSLog(@"\n%@\n%@",NSStringFromCGRect([userInfoDic[UIKeyboardFrameBeginUserInfoKey] CGRectValue]),
          NSStringFromCGRect([userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue]));
    NSLog(@"收回的动画时间间隔%lf",[userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    NSLog(@"收回的时间曲线%ld",[userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]);
    // ============================================================
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options \
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

- (void)textDidChange:(NSNotification *)notification
{
    //NSInteger wordCount = self.text.length;
    NSInteger wordCount = self.textView.text.length;

    //NSLog(@">>workCount:%ld,\n>>self.textView.text.length:%ld",wordCount,self.textView.text.length);
    
    NSString *changeShowText = [NSString stringWithFormat:@"%ld",(long)wordCount];
    NSString *showText = [NSString stringWithFormat:@"%ld/%ld",(long)wordCount,_limitNum];
    NSInteger strCharLength = changeShowText.length;
    
    UIColor *showTextColor = QuickWordInputView_ThemeColor;
    if(![self wordLimit:wordCount]){
        showTextColor = [UIColor redColor];
    }
    // 设置富文本
    NSMutableAttributedString *attributedString = [self setAttributedString:showText textColor:showTextColor range:NSMakeRange(0, strCharLength)];
    
    
    self.numberLabel.attributedText = attributedString;
    
    
}

- (NSMutableAttributedString*)setAttributedString:(NSString*)text
                                        textColor:(UIColor*)textColor
                                            range:(NSRange)range{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:textColor
                             range:range];
    return attributedString;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)wordLimit:(NSInteger) length{
    if (length <= _limitNum) {
        self.textView.editable = YES;
        return YES;
    }
    else{
        
        return NO;
    }
    return YES;
}




@end
