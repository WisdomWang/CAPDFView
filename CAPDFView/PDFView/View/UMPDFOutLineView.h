//
//  UMPDFOutLineView.h
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMPDFOutLineView : UIView

@property (nonatomic, strong) PDFOutline *outlineRoot;
@property (nonatomic,copy)  void(^doneBlock)(PDFOutline *outline);

- (void)gotoDismiss;

@end

NS_ASSUME_NONNULL_END
