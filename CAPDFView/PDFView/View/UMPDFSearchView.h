//
//  UMPDFSearchView.h
//  UmerChat
//
//  Created by umer on 2020/12/4.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
#import <MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

@interface UMPDFSearchView : UIView<UITextFieldDelegate,PDFDocumentDelegate>

@property (nonatomic,strong) UITextField *searchText;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIButton*upButton;
@property (nonatomic,strong) UIButton*downButton;

@property (nonatomic,copy) void(^dismissBlock)();

@property (nonatomic,copy) void(^upBlock)(NSMutableArray *searchResultArray);
@property (nonatomic,copy) void(^downBlock)(NSMutableArray *searchResultArray);
@property (nonatomic,copy) void(^keywordChangeBlock)(NSMutableArray *searchResultArray);

@property (strong, nonatomic) PDFDocument *pdfDocument;
@property (strong, nonatomic) NSMutableArray<PDFSelection *> *searchResultArray;

@property (nonatomic,strong) MBProgressHUD *hud;

- (void)gotoDismiss;

@end

NS_ASSUME_NONNULL_END
