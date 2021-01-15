//
//  UMReadPDFTopView.m
//  UmerChat
//
//  Created by umer on 2020/12/7.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "UMReadPDFTopView.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"

@implementation UMReadPDFTopView

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(gotoPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(11);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
    }];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton addTarget:self action:@selector(RightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton setImage:[UIImage imageNamed:@"icon_more_black"] forState:UIControlStateNormal];
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-11);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
    }];
}

- (void)gotoPop:(UIButton *)button {
    self.leftButtonBlock();
}

- (void)RightButtonClick:(UIButton *)button {
    self.rightButtonBlock();
}

@end
