//
//  ViewController.m
//  QuickWordsViewDemo
//
//  Created by HEYANG on 16/12/9.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>

#import "QuickWordsView.h"

// 最底部的UIWindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *showTextLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)showBtn:(id)sender {
    // 显示
    __weak ViewController *weakSelf = self;
    [QuickWordsView showWithSendTextBlock:^(id objc) {
        __strong ViewController *self = weakSelf;
        NSLog(@"最终传出来的Text对象:%@",objc);
        self.showTextLabel.text = (NSString*)objc;
        [self.showTextLabel sizeToFit];
    }];
    
}

- (IBAction)hideBtn:(id)sender {
    // 隐藏
    [QuickWordsView hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
