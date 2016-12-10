//
//  QuickWordsView.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordsView.h"
#import "QuickWordsModels.h"
#import "QuickWordsTableView.h"
#import "QuickWordInputView.h"
#import "UIWindow+QuickWordsExtra.h"

@interface QuickWordsView ()
<QuickWordsTableViewDelegate,QuickWordInputViewDelegate>

@property (nonatomic,weak) QuickWordsView *weak_QuickWordsView;

// 考虑到宏定义的特性，就是编译的时候替换内容，但不做计算，
// 所以特意定义变量，在初始化的时候就进行计算比较好
@property (nonatomic,assign) CGFloat qw_TopHeight;
@property (nonatomic,assign) CGFloat qw_CenterHeight;
@property (nonatomic,assign) CGFloat qw_CenterY;
@property (nonatomic,assign) CGFloat qw_BottomHeight;
@property (nonatomic,assign) CGFloat qw_BottomY;
@property (nonatomic,assign) CGFloat qw_Width;
@property (nonatomic,assign) CGFloat qw_Height;
@property (nonatomic,assign) CGFloat qw_Y;
@property (nonatomic,assign) CGFloat qw_CenterTitleLRSpace;

@property (nonatomic,strong) UIButton *leftBtn;// 删除按钮
@property (nonatomic,strong) UIButton *rightAddBtn;// 添加按钮
@property (nonatomic,strong) UILabel *centerTitle;// 中间提示语Lable
@property (nonatomic,strong) QuickWordsTableView *qwTableView;
//@property (nonatomic,weak)   QuickWordInputView *inputView;

@property (nonatomic,assign) QuickWordsState state;
@property (nonatomic,assign) QuickWordsReviseState reviseState;

@property (nonatomic,copy) void (^sendTextBlock)(id objc);

@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation QuickWordsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        _qw_TopHeight = Q_TopHeight;
        _qw_CenterY = _qw_TopHeight+SpaceLineWidth;
        _qw_CenterHeight = Q_CenterHeight;
        _qw_BottomY = _qw_TopHeight+_qw_CenterHeight+SpaceLineWidth*2;
        _qw_BottomHeight = Q_BottomHeight;
        _qw_Width = QuickWordsView_Width;
        _qw_Height = QuickWordsView_Height;
        _qw_Y = QuickWordsView_Y;
        _qw_CenterTitleLRSpace = CenterTitleLRSpace;
        
        _state = QuickWordsStateSelection;
        
        _selectedIndex = -1;// 一开始就是未选中的位置
    }
    return self;
}

+ (instancetype)getQuickWordsView{
    QuickWordsView *qucikWordsView = [QuickWordsView new];
    qucikWordsView.frame = CGRectMake(0, UIScreenHeight, qucikWordsView.qw_Width, qucikWordsView.qw_Height);
    qucikWordsView.backgroundColor = [UIColor colorWithRed:0.96
                                                     green:0.96
                                                      blue:0.96
                                                     alpha:1];
    
    // ==== 1、顶部View ====
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, qucikWordsView.qw_Width, qucikWordsView.qw_TopHeight);
    topView.backgroundColor = [UIColor whiteColor];
    [qucikWordsView addSubview:topView];
    
    // 顶部View添加两个按钮，一个标题
    // 删除按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, qucikWordsView.qw_TopHeight, qucikWordsView.qw_TopHeight);
    [leftBtn setTitle:@"删除" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    [leftBtn addTarget:qucikWordsView action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    qucikWordsView.leftBtn = leftBtn;
    // 添加按钮
    UIButton *rightAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightAddBtn.frame = CGRectMake(qucikWordsView.qw_Width-qucikWordsView.qw_TopHeight, 0, qucikWordsView.qw_TopHeight, qucikWordsView.qw_TopHeight);
    [rightAddBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightAddBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightAddBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    [rightAddBtn addTarget:qucikWordsView action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightAddBtn];
    qucikWordsView.rightAddBtn = rightAddBtn;
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我的常用回复";
    titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.center = topView.center;
    
    // ==== 2、中间内容View ====
    UIView *centerView = [UIView new];
    centerView.frame = CGRectMake(0, qucikWordsView.qw_CenterY, qucikWordsView.qw_Width, qucikWordsView.qw_CenterHeight);
    centerView.backgroundColor = [UIColor whiteColor];
    [qucikWordsView addSubview:centerView];
    // 中间内容需要有个提示语:您还未添加常用回复，点击新增，扩充您的常用语，提高聊天效率
    UILabel *centerTitle = [UILabel new];
    centerTitle.numberOfLines = 0;
    centerTitle.frame = CGRectMake(qucikWordsView.qw_CenterTitleLRSpace, 0, qucikWordsView.qw_Width-qucikWordsView.qw_CenterTitleLRSpace*2, qucikWordsView.qw_CenterHeight);
    centerTitle.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    centerTitle.font = [UIFont systemFontOfSize:15];
    centerTitle.text = @"您还未添加常用回复，点击新增，扩充您的常用语，提高聊天效率";
    centerTitle.textAlignment = NSTextAlignmentCenter;// 设置文本居中样式
    [centerView addSubview:centerTitle];
    qucikWordsView.centerTitle = centerTitle;
    // 添加UITableView列表，但是这里要清楚的逻辑：
    // 1、没有快捷语的时候，列表隐藏 2、有快捷语的时候，列表显示，并展示快捷语
    // 所以，要先处理快捷语内容数据
    NSArray *wordsArr = [QuickWordsModels getQuickWordsArr];
    QuickWordsTableView *qwTableView = [QuickWordsTableView new];
    qwTableView.qwDelegate = qucikWordsView;
    qwTableView.frame = centerView.bounds;
    qwTableView.words = wordsArr;
    [centerView addSubview:qwTableView];
    qucikWordsView.qwTableView = qwTableView;
    [qwTableView setHidden:![QuickWordsModels isHasWord]];
    
    // ==== 3、底部View,直接用Button ====
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, qucikWordsView.qw_BottomY, qucikWordsView.qw_Width, qucikWordsView.qw_BottomHeight);
    bottomButton.backgroundColor = [UIColor whiteColor];
    [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    [bottomButton addTarget:[QuickWordsView class]
                     action:@selector(hide)
           forControlEvents:UIControlEventTouchUpInside];
    [qucikWordsView addSubview:bottomButton];
    
    return qucikWordsView;
}

+ (void)showWithSendTextBlock:(void (^)(id objc))bloc{
    if (![kQWKeyWindow quickWordsView]) {
        // 创建蒙板
        UIView *maskView = [UIView new];
        maskView.frame = UIScreenBounds;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;// 开始是透明的
        [kQWKeyWindow addSubview:maskView];
        [kQWKeyWindow setQwMaskView:maskView];
        
        
        // 创建快捷语View ，在里面的Frame的Y = 0,
        QuickWordsView *qwView = [QuickWordsView getQuickWordsView];
        qwView.sendTextBlock = bloc;
        [kQWKeyWindow addSubview:qwView];
        [kQWKeyWindow setQuickWordsView:qwView];
        
        // 给蒙板添加手势 类方法注意Target参数传的是这个类，不是对象
        UITapGestureRecognizer *tapSheet = [[UITapGestureRecognizer alloc] initWithTarget:[QuickWordsView class] action:@selector(hide)];
        [maskView addGestureRecognizer:tapSheet];
        
        // 动画显示 蒙板透明度:UIScreenHeight->0.4  快捷语View的y值:0->qwView.qw_Y
        [UIView animateWithDuration:0.2 animations:^{
            maskView.alpha  = 0.4;
            qwView.frame    = CGRectMake(0, qwView.qw_Y, qwView.qw_Width, qwView.qw_Height);
        }];
    }
}


+ (void)hide{
    if ([kQWKeyWindow quickWordsView]) {
        [UIView animateWithDuration:0.2 animations:^{
            QuickWordsView* qwView = [kQWKeyWindow quickWordsView];
            [kQWKeyWindow quickWordsView].frame  = CGRectMake(0, UIScreenHeight, qwView.qw_Width, qwView.qw_Height);
            [kQWKeyWindow qwMaskView].alpha = 0;
        } completion:^(BOOL finished) {
            [[kQWKeyWindow qwMaskView] removeFromSuperview];
            [[kQWKeyWindow quickWordsView] removeFromSuperview];
            [kQWKeyWindow setQwMaskView:nil];
            [kQWKeyWindow setQuickWordsView:nil];
        }];
    }
}

#pragma mark - QuickWordsTableViewDelegate
- (void)qwTableView:(QuickWordsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    NSString *selectedStr = [QuickWordsModels getQuickWordIndex:indexPath.row];
    
    //NSLog(@"选中的字符串是:%@",selectedStr);
    //[self sendText:selectedStr]; // 直接发送，但是Boss直聘不是这样的
    QuickWordInputView *inputView = [QuickWordInputView getQuickWordsInputView];
    inputView.delegate = self;
    [inputView showWithText:selectedStr];
    _reviseState = QuickWordsReviseStateEdit;
    
}
- (void)qwTableView:(QuickWordsTableView *)tableView deletedRowAtIndex:(NSInteger)index{
    NSArray *wordsArr = [QuickWordsModels deleteQuickWordsInIndex:index];
    if ([QuickWordsModels isHasWord]) {
        tableView.words = wordsArr;
    }else{
        [tableView setHidden:YES];
    }
}

#pragma mark - Events
- (void)leftBtn:(UIButton*)sender{
    // 左边按钮，需要切换的状态有
    // 1、左边按钮 删除<-->完成 2、添加按钮 添加<-->不显示 3、TableView 选择<-->删除
    switch (_state) {
        case QuickWordsStateSelection:{
            _state = QuickWordsStateDelete;
            // 现在要切换成正在删除状态
            // 左边按钮显示"完成"
            [_leftBtn setTitle:@"完成" forState:UIControlStateNormal];
            // 右边按钮就要不显示
            [_rightAddBtn setHidden:YES];
            
        }
            break;
        case QuickWordsStateDelete:{
            _state = QuickWordsStateSelection;
            // 现在要切换成正在选中状态
            // 左边按钮显示"取消"
            [_leftBtn setTitle:@"删除" forState:UIControlStateNormal];
            // 右边按钮就要显示出来
            [_rightAddBtn setHidden:NO];
        }
            break;
        default:
            break;
    }
    if (_qwTableView) {
        _qwTableView.tableViewState = _state;
    }
}

- (void)rightBtn:(UIButton*)sender{
    
    NSLog(@"开始添加");
    QuickWordInputView *inputView = [QuickWordInputView getQuickWordsInputView];
    inputView.delegate = self;
    [inputView show];
    _reviseState = QuickWordsReviseStateAdd;
    
}

#pragma mark - QuickWordInputViewDelegate
- (void)clickedSaveBtn:(QuickWordInputView*)inputView
              saveText:(NSString*)text{
    NSLog(@"保存的字符串:%@",text);
    NSArray *wordsArr;
    
    switch (_reviseState) {
        case QuickWordsReviseStateEdit:{
            wordsArr = [QuickWordsModels editQuickWord:text index:_selectedIndex];
            break;
        }
        case QuickWordsReviseStateAdd:{
            wordsArr = [QuickWordsModels addQuickWord:text];
            break;
        }
        default:
            
            break;
    }
    
    
    if ([QuickWordsModels isHasWord]) {
        [_qwTableView setHidden:NO];
        _qwTableView.words = wordsArr;
    }else{
        [_qwTableView setHidden:YES];
    }
}
- (void)clickedSendBtn:(QuickWordInputView*)inputView
              sendText:(NSString*)text{
    NSLog(@"发送的字符串:%@",text);
    
    [self sendText:text];
    
}

- (void)sendText:(NSString*)text{
    if (_sendTextBlock) {
        _sendTextBlock(text);
    }
    [QuickWordsView hide];

}

@end



