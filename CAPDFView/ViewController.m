//
//  ViewController.m
//  CAPDFView
//
//  Created by umer on 2021/1/15.
//  Copyright © 2021 umer. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "PDFReadViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"打开PDF" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoPDF:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
}

- (void)gotoPDF:(UIButton *)button {
    PDFReadViewController *vc = [[PDFReadViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
