//
//  TipView.h
//  DoctorPhotos
//
//  Created by umer on 2020/4/15.
//  Copyright © 2020 umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TipView : NSObject

+ (void)showInfoMessage:(NSString *)message;
+ (void)showInfoMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;
+ (void)showInfoMessage:(NSString *)message inView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
