//
//  QuickWordsTableView.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordsTableView.h"

#import "QuickWordsCell.h"

@interface QuickWordsTableView ()
<
UITableViewDataSource
,UITableViewDelegate
>

@end

@implementation QuickWordsTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _tableViewState = QuickWordsStateSelection;
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 注册Cell
        [QuickWordsCell registerInTableView:self];
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _words.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [QuickWordsCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuickWordsCell *cell = [QuickWordsCell getQuickWordsCell:tableView
                                                forIndexPath:indexPath];
    [cell.deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    switch (_tableViewState) {
        case QuickWordsStateSelection:{
            [cell.deleteBtn setHidden:YES];// 隐藏
        }
            break;
        case QuickWordsStateDelete:{
            [cell.deleteBtn setHidden:NO];// 显示
        }
            break;
        default:
            break;
    }
    NSString *qwText = [NSString stringWithFormat:@"%ld.%@",indexPath.row+1,_words[indexPath.row]];
    cell.titleLable.text = qwText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if (_qwDelegate && [_qwDelegate respondsToSelector:@selector(qwTableView:didSelectRowAtIndexPath:)]) {
        [_qwDelegate qwTableView:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - Events
- (void)deleteCell:(UIButton*)sender{
    NSInteger deleteNum = sender.tag - ButtonTagExtraCount;
    NSLog(@"删除掉第%ld个Cell",deleteNum);
    if (_qwDelegate && [_qwDelegate respondsToSelector:@selector(qwTableView:deletedRowAtIndex:)]) {
        [_qwDelegate qwTableView:self deletedRowAtIndex:deleteNum];
    }
}

#pragma mark - Set Get
- (void)setTableViewState:(QuickWordsState)tableViewState{
    _tableViewState = tableViewState;
    [self reloadData];
}
- (void)setWords:(NSArray<NSString *> *)words{
    _words = words;
    [self reloadData];
}

@end
