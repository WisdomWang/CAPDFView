//
//  UMPDFOutLineView.m
//  UmerChat
//
//  Created by umer on 2020/12/3.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "UMPDFOutLineView.h"
#import "UMPDFOutLineCell.h"
#import <Masonry.h>
#import "UIColor+ColorHex.h"
#import "TheDefine.h"

NSString *const xPDFOutLineViewCell = @"PDFOutLineViewCell";

@interface UMPDFOutLineView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIView *userHeaderView;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation UMPDFOutLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.6];
        [self createViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)createViews {
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth/1.73, kScreenHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MNIphonexAddTopSafeArea(0),kScreenWidth/1.73,kScreenHeight-MNIphonexAddTopSafeArea(0)) style:UITableViewStylePlain];
     _mainTableView.backgroundColor = [UIColor whiteColor];
     _mainTableView.delegate = self;
     _mainTableView.dataSource = self;
     _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.tableHeaderView = self.userHeaderView;
     _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     _mainTableView.rowHeight = 44;
     [_mainTableView registerClass:[UMPDFOutLineCell class] forCellReuseIdentifier:xPDFOutLineViewCell];
     [bgView addSubview:_mainTableView];
    
}

- (UIView *)userHeaderView {
    if (!_userHeaderView) {
        _userHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"目录";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16];
        [_userHeaderView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_userHeaderView.mas_centerX);
            make.centerY.equalTo(_userHeaderView.mas_centerY);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(100);
        }];
    }
    return _userHeaderView;
}

#pragma mark - --- Customed Methods ---

- (void)insertOulineWithParentOutline:(PDFOutline *)parentOutline
{
    NSInteger baseIndex = [self.arrData indexOfObject:parentOutline];
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++)
    {
        PDFOutline *tempOuline = [parentOutline childAtIndex:i];
        tempOuline.isOpen = NO;
        [self.arrData insertObject:tempOuline atIndex:baseIndex + i + 1];
    }
}

- (void)removeOutlineWithParentOuline:(PDFOutline *)parentOutline
{
    if (parentOutline.numberOfChildren <= 0)
    {
        return;
    }
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++)
    {
        PDFOutline *node = [parentOutline childAtIndex:i];
        
        if (node.numberOfChildren > 0 && node.isOpen)
        {
            [self removeOutlineWithParentOuline:node];
            
            NSInteger index = [self.arrData indexOfObject:node];
            
            if (index)
            {
                [self.arrData removeObjectAtIndex:index];
            }
        }
        else
        {
            if ([self.arrData containsObject:node])
            {
                NSInteger index = [self.arrData indexOfObject:node];
                
                if (index)
                {
                    [self.arrData removeObjectAtIndex:index];
                }
            }
        }
    }
}

- (NSInteger)findDepthWithOutline:(PDFOutline *)outline
{
    NSInteger depth = -1;
    PDFOutline *tempOutline = outline;
    
    while (tempOutline.parent != nil)
    {
        depth++;
        tempOutline = tempOutline.parent;
    }
    
    return depth;
}

#pragma mark - --- UITableView DataSource ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMPDFOutLineCell *cell = [tableView dequeueReusableCellWithIdentifier:xPDFOutLineViewCell forIndexPath:indexPath];
    
    PDFOutline *outline = self.arrData[indexPath.row];
    
    cell.lblTitle.text = outline.label;
    cell.btnArrow.selected = outline.isOpen;
    
    if (outline.numberOfChildren > 0)
    {
        [cell.btnArrow setImage:outline.isOpen ? [UIImage imageNamed:@"outline_arrow_down"] : [UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [cell.btnArrow setEnabled:YES];
    }
    else
    {
        [cell.btnArrow setImage:nil forState:UIControlStateNormal];
        [cell.btnArrow setEnabled:NO];
    }
    
    cell.outlineBlock = ^(UIButton * _Nonnull button) {

        if (outline.numberOfChildren > 0)
        {
            if (button.isSelected)
            {
                outline.isOpen = YES;
                [self insertOulineWithParentOutline:outline];
            }
            else
            {
                outline.isOpen = NO;
                [self removeOutlineWithParentOuline:outline];
            }

            [tableView reloadData];
        }

    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDFOutline *outline = self.arrData[indexPath.row];
    NSInteger depth = [self findDepthWithOutline:outline];
    
    return depth;
}

#pragma mark - --- UITableView Delegate ---

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    
    PDFOutline *outline = [self.arrData objectAtIndex:indexPath.row];
    
    self.doneBlock(outline);
    
    [self gotoDismiss];
}

#pragma mark - --- Setter & Getter ---
- (NSMutableArray *)arrData
{
    if (!_arrData)
    {
        _arrData = [[NSMutableArray alloc] init];
    }
    
    return _arrData;
}

- (void)setOutlineRoot:(PDFOutline *)outlineRoot
{
    for (int i = 0; i < outlineRoot.numberOfChildren; i++)
    {
        PDFOutline *outline = [outlineRoot childAtIndex:i];
        outline.isOpen = NO;
        [self.arrData addObject:outline];
    }
    
    [self.mainTableView reloadData];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

- (void)gotoDismiss {
    [self removeFromSuperview];
}

@end
