//
//  ViewController.m
//  Bot
//
//  Created by tiny on 16/9/27.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xffffff);
    [self initUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initUI {
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, 100, SW, 30);
    btnNext.backgroundColor = HEX_RGB(0xececec);
    [btnNext addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
}

- (void)gotoNext {
    ChatViewController *chatView = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
