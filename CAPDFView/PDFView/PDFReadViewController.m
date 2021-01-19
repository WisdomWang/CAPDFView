//
//  PDFReadViewController.m
//  CAPDFView
//
//  Created by umer on 2021/1/15.
//  Copyright © 2021 umer. All rights reserved.
//

#import "PDFReadViewController.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"
#import <PDFKit/PDFKit.h>
#import "UMReadPDFBottomView.h"
#import "UMPDFOutLineView.h"
#import "PDFImageAnnotation.h"
#import "UMPDFSearchView.h"
#import "IQKeyboardManager.h"
#import "UMReadPDFTopView.h"
#import "UIButton+zt_adjustImageAndTitle.h"
#import "TipView.h"
#import <MBProgressHUD.h>

@interface PDFReadViewController ()

@property (nonatomic,strong) PDFDocument *document;
@property (nonatomic,strong) PDFView *pdfView;

@property (nonatomic,copy) NSString *documentName;

@property (nonatomic,strong) PDFPage *lastPage;
@property (nonatomic,strong) PDFImageAnnotation *lastAnnotation;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) UMReadPDFTopView *topView;
@property (nonatomic,strong) UMReadPDFBottomView * bottomView;

@property (nonatomic,strong) UILabel *pageLabel;
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) UMPDFSearchView * searchView;
@property (nonatomic,strong) UMPDFOutLineView *alertView;

@end

@implementation PDFReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageIndex = 0;
    _isShow = YES;
    [self initViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChange:) name:PDFViewPageChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initViews {
    __weak typeof(self) weakSelf = self;
    NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"003" ofType:@"pdf"];
    self.documentName = @"003.pdf";
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfPath];
    self.document = [[PDFDocument alloc] initWithURL:pdfUrl];
    self.pdfView = [[PDFView alloc]initWithFrame:self.view.bounds];
    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
    self.pdfView.document = self.document;
    self.pdfView.autoScales = YES;
    self.pdfView.userInteractionEnabled = YES;
    self.pdfView.displayMode = kPDFDisplaySinglePageContinuous;
    [self.pdfView usePageViewController:YES withViewOptions:nil];
    self.pdfView.backgroundColor = [UIColor colorWithHexString:@"#B6BDC0"];
    [self.view addSubview:self.pdfView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTabShow)];
    [self.pdfView addGestureRecognizer:tap];
    
    self.pageLabel = [[UILabel alloc]init];
    self.pageLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.pageLabel.font = [UIFont systemFontOfSize:12];
    self.pageLabel.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    self.pageLabel.layer.cornerRadius = 2;
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.layer.masksToBounds = YES;
    NSInteger currentPageNum = [self.document indexForPage:self.pdfView.currentPage];
    if (self.document.pageCount == 0) {
        self.pageLabel.text = @"0/0";
    } else {
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentPageNum+1,self.document.pageCount];
    }
    [self.view addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-28-MNIphonexAddBottomSafeArea(0));
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *pageLabel = [defaults valueForKey:self.documentName];
    if (pageLabel) {
        self.lastPage = [self.document pageAtIndex:[pageLabel integerValue]-1];
        CGRect bounds = [self.lastPage boundsForBox:kPDFDisplayBoxMediaBox];
        PDFImageAnnotation *annotation = [[PDFImageAnnotation alloc]initWithPicture:[UIImage imageNamed:@"icon_bookmark"] bounds:CGRectMake(bounds.size.width-14-11, bounds.size.height-21, 14, 21)];
       // PDFImageAnnotation *annotation = [[PDFImageAnnotation alloc]initWithPicture:[UIImage imageNamed:@"icon_bookmark"] bounds:CGRectMake(595-14-11, 842-21, 14, 21)];
        [self.lastPage addAnnotation:annotation];
        self.lastAnnotation = annotation;
        [self.pdfView goToPage:self.lastPage];
        NSInteger pageNum = [self.document indexForPage:self.lastPage];
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",pageNum+1,(unsigned long)self.document.pageCount];
    }
    
        self.topView = [[UMReadPDFTopView alloc]init];
        self.topView.frame = CGRectMake(0, 0, kScreenWidth, xTopHeight);
        [self.view addSubview:self.topView];
        self.topView.leftButtonBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        };
        self.topView.rightButtonBlock = ^{
        };
        
        self.bottomView = [[UMReadPDFBottomView alloc]init];
        self.bottomView.frame = CGRectMake(0, kScreenHeight-49-MNIphonexAddBottomSafeArea(0), kScreenWidth, 49+MNIphonexAddBottomSafeArea(0));
        [self.view addSubview:self.bottomView];
        self.bottomView.detailBlock = ^(NSInteger index) {
            switch (index) {
                    case 0:
                    NSLog(@"目录");
                    [weakSelf gotoOutline];
                    break;
                    case 1:
                    NSLog(@"书签");
                    [weakSelf addBookMark];
                    break;
                    case 2:
                    NSLog(@"查找");
                    [weakSelf gotoSearch];
                    break;
                default:
                    break;
            }
        };
}

- (void)gotoOutline {
    
    __weak typeof(self) weakSelf = self;
    PDFOutline *outline = self.document.outlineRoot;
    
    if (outline)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.alertView  = [[UMPDFOutLineView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.alertView.outlineRoot = outline;
        self.alertView.doneBlock = ^(PDFOutline * _Nonnull outline) {
            
            PDFAction *action = outline.action;
            PDFActionGoTo *goToAction = (PDFActionGoTo *)action;
            if (goToAction)
            {
                [weakSelf.pdfView goToDestination:goToAction.destination];
            }
        };
        [window insertSubview:self.alertView aboveSubview:window];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此书还没有编辑目录" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)gotoSearch {
    
    __weak typeof(self) weakSelf = self;
    
    self.searchView = [[UMPDFSearchView alloc]init];
    self.searchView.pdfDocument = self.document;
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(56+MNIphonexAddBottomSafeArea(0));
    }];
    self.searchView.dismissBlock = ^{
         weakSelf.pdfView.highlightedSelections = nil;
         [weakSelf.pdfView clearSelection];
    };
    self.searchView.keywordChangeBlock = ^(NSMutableArray * _Nonnull searchResultArray){
        weakSelf.pageIndex = 0;
        if (searchResultArray.count == 0) {
        weakSelf.pdfView.highlightedSelections = nil;
        } else {
        weakSelf.pdfView.highlightedSelections = searchResultArray;
        }
    };
    self.searchView.upBlock = ^(NSMutableArray * _Nonnull searchResultArray) {
        
        if (searchResultArray.count == 0) {
            return;
        }
        
        if (weakSelf.pageIndex != 0) {
            weakSelf.pageIndex = self.pageIndex -1;
        } else {
            weakSelf.pageIndex = 0;
        }
        
        PDFSelection *selection = searchResultArray[weakSelf.pageIndex];
        [weakSelf.pdfView goToSelection:selection];
       // weakSelf.pdfView.currentSelection = selection;
        [weakSelf.pdfView setCurrentSelection:selection animate:YES];
        
    };
    self.searchView.downBlock = ^(NSMutableArray * _Nonnull searchResultArray) {
        if (searchResultArray.count == 0) {
            return;
        }
 
        PDFSelection *selection = searchResultArray[weakSelf.pageIndex];
        [weakSelf.pdfView goToSelection:selection];
        //weakSelf.pdfView.currentSelection = selection;
        [weakSelf.pdfView setCurrentSelection:selection animate:YES];
         weakSelf.pageIndex = self.pageIndex +1;
         if (weakSelf.pageIndex == searchResultArray.count) {
             weakSelf.pageIndex = weakSelf.pageIndex-1;
         }

    };
    
    [self.searchView.searchText becomeFirstResponder];
}

- (void)addBookMark {
   
//    PDFAnnotation *markImg = [[PDFAnnotation alloc]initWithBounds:CGRectMake(595-60, 842-40, 60, 40) forType:PDFAnnotationSubtypeWidget withProperties:nil];
//    markImg.widgetFieldType = PDFAnnotationWidgetSubtypeButton;
//    markImg.widgetControlType = kPDFWidgetPushButtonControl;
//    markImg.caption = @"书签";
//    [[self.pdfView.document pageAtIndex:0] addAnnotation:markImg];
    
    if (self.document.pageCount == 0) {
        [TipView showInfoMessage:@"此书暂无内容" hideAfterDelay:2];
         return;
     }
    
    if (self.lastPage) {
        if (self.lastPage == self.pdfView.currentPage) {
            [TipView showInfoMessage:@"取消书签成功" hideAfterDelay:2];
            [self.lastPage removeAnnotation:self.lastAnnotation];
            self.lastPage = nil;
            self.lastAnnotation = nil;
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:self.documentName];
            return;
        }
        [self.lastPage removeAnnotation:self.lastAnnotation];
    }
    
    CGRect bounds = [self.pdfView.currentPage boundsForBox:kPDFDisplayBoxMediaBox];
    PDFImageAnnotation *annotation = [[PDFImageAnnotation alloc]initWithPicture:[UIImage imageNamed:@"icon_bookmark"] bounds:CGRectMake(bounds.size.width-14-11, bounds.size.height-21, 14, 21)];
   // PDFImageAnnotation *annotation = [[PDFImageAnnotation alloc]initWithPicture:[UIImage imageNamed:@"icon_bookmark"] bounds:CGRectMake(595-14-11, 842-21, 14, 21)];
    [self.pdfView.currentPage addAnnotation:annotation];
    NSLog(@"%@",self.pdfView.currentPage.label);
    self.lastPage = self.pdfView.currentPage;
    self.lastAnnotation = annotation;
    [[NSUserDefaults standardUserDefaults]setValue:self.pdfView.currentPage.label forKey:self.documentName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"firstAddBookMark"] isEqualToString:@"1"]) {
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"书签添加成功，下次进入将自动跳转本页" preferredStyle:UIAlertControllerStyleAlert];
         
         [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstAddBookMark"];
         }]];
         [self presentViewController:alert animated:true completion:nil];
     } else {
         [TipView showInfoMessage:@"添加书签成功" hideAfterDelay:2];
     }
    [self.pdfView goToFirstPage:nil];
    [self.pdfView goToPage:self.lastPage];
}

- (void)changeTabShow {
    if (_isShow == YES) {

        [self tabHide];
    } else {
        [self tabShow];
    }
    _isShow = !_isShow;
}


- (void)tabShow {
    
    [UIView animateWithDuration:0.25 animations:^{
         self.topView.frame = CGRectMake(0, 0, kScreenWidth, xTopHeight);
         self.bottomView.frame = CGRectMake(0, kScreenHeight-49-MNIphonexAddBottomSafeArea(0), kScreenWidth, 49+MNIphonexAddBottomSafeArea(0));
     } completion:^(BOOL finished) {
         
     }];
}

- (void)tabHide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.frame = CGRectMake(0, -xTopHeight, kScreenWidth, xTopHeight);
        self.bottomView.frame = CGRectMake(0, kScreenHeight+49+MNIphonexAddBottomSafeArea(0), kScreenWidth, 49+MNIphonexAddBottomSafeArea(0));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)pageChange:(NSNotificationCenter *)noti {
    
    NSInteger currentPageNum = [self.document indexForPage:self.pdfView.currentPage];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",currentPageNum+1,(unsigned long)self.document.pageCount];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
