//
//  QuickWordsCell.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordUtilities.h"

#define QuickWordsCell_ID @"QuickWordsCell_ID"

#define ButtonTagExtraCount 99

@interface QuickWordsCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIButton *deleteBtn;//删除按钮

+ (void)registerInTableView:(UITableView*)tableView;
+ (instancetype)getQuickWordsCell:(UITableView*)tableView forIndexPath:(NSIndexPath *)indexPath;


// 返回的Cell的高度
+ (CGFloat)cellHeight;

@end
