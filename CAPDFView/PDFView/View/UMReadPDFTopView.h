//
//  UMReadPDFTopView.h
//  UmerChat
//
//  Created by umer on 2020/12/7.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMReadPDFTopView : UIView

@property (nonatomic,copy) void(^leftButtonBlock)();
@property (nonatomic,copy) void(^rightButtonBlock)();

@property (nonatomic,strong) UIButton *moreButton;

@end

NS_ASSUME_NONNULL_END
