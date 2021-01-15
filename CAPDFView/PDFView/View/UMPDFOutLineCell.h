//
//  UMPDFOutLineCell.h
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OutlineButtonBlock)(UIButton * _Nonnull button);
NS_ASSUME_NONNULL_BEGIN

@interface UMPDFOutLineCell : UITableViewCell
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIButton *btnArrow;
@property (nonatomic, copy) OutlineButtonBlock outlineBlock;
@end

NS_ASSUME_NONNULL_END
