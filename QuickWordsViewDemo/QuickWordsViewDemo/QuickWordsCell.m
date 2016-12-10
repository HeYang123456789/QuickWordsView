//
//  QuickWordsCell.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "QuickWordsCell.h"

#define QuickWordsCell_Height kScaleFrom_iPhone6_Height(44)
#define TitleLable_width UIScreenWidth - 40
#define titleFont [UIFont systemFontOfSize:13.0]
#define titleColor [UIColor lightGrayColor]

@interface QuickWordsCell ()



@end

@implementation QuickWordsCell

+ (void)registerInTableView:(UITableView*)tableView{
    
    [tableView registerClass:[QuickWordsCell class]
      forCellReuseIdentifier:QuickWordsCell_ID];
}

+ (instancetype)getQuickWordsCell:(UITableView*)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    QuickWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:QuickWordsCell_ID forIndexPath:indexPath];
    cell.deleteBtn.tag = indexPath.row + ButtonTagExtraCount;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        // 标题
        _titleLable = ({
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(20, 0, TitleLable_width, QuickWordsCell_Height);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = titleFont;
            label.textColor = titleColor;
            label;
        });
        [self.contentView addSubview:_titleLable];
        
        //删除图片
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame =  CGRectMake(UIScreenWidth - TitleLable_width, 0, 100, QuickWordsCell_Height);
        deleteBtn.imageView.contentMode = UIViewContentModeRight;
        [deleteBtn  setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-8);
            make.width.equalTo(@100);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

+ (CGFloat)cellHeight{
    return QuickWordsCell_Height;
}

@end
