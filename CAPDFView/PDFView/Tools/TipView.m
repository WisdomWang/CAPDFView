//
//  TipView.m
//  DoctorPhotos
//
//  Created by umer on 2020/4/15.
//  Copyright © 2020 umer. All rights reserved.
//

#import "TipView.h"
#import "MBProgressHUD.h"

@implementation TipView

+ (void)showInfoMessage:(NSString *)message inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    if (view == nil) {
        view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = hud.label.font;
    hud.detailsLabel.textColor = hud.label.textColor;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}
+ (void)showInfoMessage:(NSString *)message {
    [self showInfoMessage:message inView:nil hideAfterDelay:1];
}

+ (void)showInfoMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self showInfoMessage:message inView:nil hideAfterDelay:delay];
}

+ (void)showInfoMessage:(NSString *)message inView:(UIView *)view {
    [self showInfoMessage:message inView:view hideAfterDelay:2];
}

@end
