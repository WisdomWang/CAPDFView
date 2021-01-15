//
//  TheDefine.h
//  CAPDFView
//
//  Created by umer on 2021/1/15.
//  Copyright © 2021 umer. All rights reserved.
//

#ifndef TheDefine_h
#define TheDefine_h


#define MNIphonexAddTopSafeArea(value) (IOS11?[UIApplication sharedApplication].keyWindow.safeAreaInsets.top+(value):(value))

#define MNIphonexAddLeftSafeArea(value) (IOS11?[UIApplication sharedApplication].keyWindow.safeAreaInsets.left+(value):(value))

#define MNIphonexAddRightSafeArea(value) (IOS11?[UIApplication sharedApplication].keyWindow.safeAreaInsets.right+(value):(value))

#define MNIphonexAddBottomSafeArea(value) (IOS11?[UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom+(value):(value))

#define IOS11            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0)

#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                    [UIScreen mainScreen].bounds.size.height

#define xStatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define xNavBarHeight       44.0f
#define xTopHeight          (xStatusBarHeight + xNavBarHeight)

#endif /* TheDefine_h */
