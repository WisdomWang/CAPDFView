//
//  UMReadPDFBottomView.m
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "UMReadPDFBottomView.h"
#import "UIButton+zt_adjustImageAndTitle.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"

@interface UMReadPDFBottomView() {
    NSArray *titleArray;
}
@end

@implementation UMReadPDFBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self  createViews];
    }
    return self;
}

- (void)createViews {
    titleArray = @[@"目录",@"书签",@"查找"];
    NSArray *imgArray = @[@"icon_pdf_outline",@"icon_pdf_bookmark",@"icon_pdf_search"];
    CGFloat bthWidth = kScreenWidth/titleArray.count;
    for (int a = 0; a<titleArray.count; a++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(bthWidth*a, 9, bthWidth, 40);
        [button setImage:[UIImage imageNamed:imgArray[a]] forState:UIControlStateNormal];
        [button setTitle:titleArray[a] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        button.tag = 800 +a;
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button.zt_contentAdjustType = ZTContentAdjustImageUpTitleDown;
        button.zt_space = 3;
        [button zt_beginAdjustContent];
    }
}

- (void)ButtonClick:(UIButton *)button {
    self.detailBlock(button.tag-800);
}

- (void)updateButtonFrame {
    CGFloat bthWidth = kScreenWidth/titleArray.count;
    for (int a = 0; a< titleArray.count; a++) {
        UIButton *button = [self viewWithTag:800+a];
        button.frame = CGRectMake(bthWidth*a, 9, bthWidth, 40);
    }
}

@end
