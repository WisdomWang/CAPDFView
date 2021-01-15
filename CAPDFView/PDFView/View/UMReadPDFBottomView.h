//
//  UMReadPDFBottomView.h
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMReadPDFBottomView : UIView

@property (nonatomic,copy) void(^detailBlock)(NSInteger index);

- (void)updateButtonFrame;
@end

NS_ASSUME_NONNULL_END
