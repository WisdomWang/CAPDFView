//
//  UMPDFOutLineCell.m
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "UMPDFOutLineCell.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"

@implementation UMPDFOutLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnArrow setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [self.btnArrow addTarget:self action:@selector(btnArrowAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnArrow];
        [self.btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.contentView.mas_top).offset(7);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
            make.width.height.mas_equalTo(30);
        }];
        self.lblTitle = [[UILabel alloc]init];
        self.lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        self.lblTitle.font = [UIFont systemFontOfSize:13];
        self.lblTitle.numberOfLines = 0;
        [self.contentView addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.btnArrow.mas_left).offset(-16);
            make.centerY.equalTo(self.btnArrow.mas_centerY);
            make.height.mas_equalTo(44);
        }];
        
    }
    return self;
}

- (void)btnArrowAction:(UIButton *)button {
    
    button.selected = !button.isSelected;

    if (self.outlineBlock)
    {
        self.outlineBlock(button);
    }
}


@end
