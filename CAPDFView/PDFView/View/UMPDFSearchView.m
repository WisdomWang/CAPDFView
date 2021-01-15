//
//  UMPDFSearchView.m
//  UmerChat
//
//  Created by umer on 2020/12/4.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "UMPDFSearchView.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"

@implementation UMPDFSearchView

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
        self.searchResultArray = [[NSMutableArray alloc]init];
        [self  createViews];
    }
    return self;
}

- (void)createViews {
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [closeButton addTarget:self action:@selector(gotoDismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).offset(8);
        make.left.equalTo(self.mas_left).offset(12+MNIphonexAddLeftSafeArea(0));
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
     _searchText = [[UITextField alloc]init];
     _searchText.placeholder = @"请输入搜索关键字";
     _searchText.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
     _searchText.textColor = [UIColor colorWithHexString:@"#666666"];
     _searchText.returnKeyType = UIReturnKeySearch;
     _searchText.font = [UIFont systemFontOfSize:14];
     _searchText.delegate = self;
     _searchText.clearButtonMode = UITextFieldViewModeNever;
     _searchText.layer.cornerRadius = 2;
     _searchText.layer.masksToBounds = YES;
     _searchText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30,36)];
     _searchText.leftViewMode = UITextFieldViewModeAlways;
     [_searchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [self addSubview:_searchText];

    
     UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_top_search"]];
     [_searchText addSubview:searchIcon];
     [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(_searchText.mas_centerY);
         make.left.equalTo(_searchText.mas_left).offset(8);
         make.width.mas_equalTo(15);
         make.height.mas_equalTo(15);
     }];
    
     self.numLabel = [[UILabel alloc]init];
     self.numLabel.textColor = [UIColor colorWithHexString:@"#666666"];
     self.numLabel.font = [UIFont systemFontOfSize:14];
     self.numLabel.text = @"共0条";
     self.numLabel.textAlignment = NSTextAlignmentRight;
     [_searchText addSubview:self.numLabel];
     [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(_searchText.mas_centerY);
         make.right.equalTo(_searchText.mas_right).offset(-12);
         make.width.mas_equalTo(100);
         make.height.mas_equalTo(20);
     }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.downButton];
    [self.downButton setImage:[UIImage imageNamed:@"icon_search_down"] forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(gotoDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeButton.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-11-MNIphonexAddRightSafeArea(0));
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.upButton];
    [self.upButton setImage:[UIImage imageNamed:@"icon_search_up"] forState:UIControlStateNormal];
    [self.upButton addTarget:self action:@selector(gotoUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeButton.mas_centerY);
        make.right.equalTo(self.downButton.mas_left).offset(-6);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [_searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeButton.mas_centerY);
        make.left.equalTo(closeButton.mas_right).offset(8);
        make.right.equalTo(self.upButton.mas_left).offset(-10);
        make.height.mas_equalTo(36);
    }];
    
    self.pdfDocument.delegate = self;
    [self.pdfDocument beginFindString:@"" withOptions:NSCaseInsensitiveSearch];
    
}

- (void)gotoDown:(UIButton *)button {
    [self.searchText resignFirstResponder];
    self.downBlock(self.searchResultArray);
}

- (void)gotoUp:(UIButton *)button {
    [self.searchText resignFirstResponder];
    self.upBlock(self.searchResultArray);
}

- (void)gotoDismiss {
    [self removeFromSuperview];
    self.dismissBlock();
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.numLabel.text = @"共0条";
        [self.searchResultArray removeAllObjects];
        self.keywordChangeBlock(self.searchResultArray);
        return;
    }
    [self.searchResultArray removeAllObjects];
    [self.pdfDocument cancelFindString];
    self.pdfDocument.delegate = self;
    [self.pdfDocument beginFindString:textField.text withOptions:NSCaseInsensitiveSearch];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)didMatchString:(PDFSelection *)instance {
    [self.searchResultArray addObject:instance];
    instance.color = [UIColor yellowColor];
}

- (void)documentDidEndDocumentFind:(NSNotification *)notification {
    self.numLabel.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.searchResultArray.count];
    self.keywordChangeBlock(self.searchResultArray);
}

@end
