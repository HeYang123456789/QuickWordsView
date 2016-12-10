//
//  QuickWordsTableView.h
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/10.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordUtilities.h"

@protocol QuickWordsTableViewDelegate;

@interface QuickWordsTableView : UITableView

@property (nonatomic,strong) NSArray<NSString*>* words;
@property (nonatomic,weak) id<QuickWordsTableViewDelegate> qwDelegate;
@property (nonatomic,assign) QuickWordsState tableViewState;

@end

@protocol QuickWordsTableViewDelegate <NSObject>

- (void)qwTableView:(QuickWordsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)qwTableView:(QuickWordsTableView *)tableView deletedRowAtIndex:(NSInteger)index;

@end
