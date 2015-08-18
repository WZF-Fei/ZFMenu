//
//  ZFMenuView.m
//  ZFMenu
//
//  Created by macOne on 15/8/18.
//  Copyright (c) 2015年 WZF. All rights reserved.
//

#import "ZFMenuView.h"
#import "ZFMenuItem.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface ZFMenuView()<UIScrollViewDelegate,ZFMenuItemDelegate>
{
    
    int xPadding;
    int yPadding;
    CGFloat width;
    CGFloat height;
    int currentPage;
}

@property(nonatomic,strong)  UIScrollView *itemsContainer;
@property(nonatomic,strong)  UIPageControl *pageControl;
@property(nonatomic) CGFloat viewWidth;
@property(nonatomic) CGFloat viewHeight;
@end

@implementation ZFMenuView
@synthesize Hcount,Vcount;

+ (id) initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)menuItems {
    
    
    ZFMenuView *tmpInstance = [[ZFMenuView alloc] initWithFrame:frame title:title items:menuItems];
    return tmpInstance;
}

- (id) initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)menuItems
{
    self = [super initWithFrame:frame];
    if (!self) return  nil;
    
    self.viewWidth = frame.size.width;
    self.viewHeight = frame.size.height;
    currentPage = 0;
    
    self.title = title;
    
    self.items = menuItems;
    self.bCenter = NO;
    
    [self initSubViews];
    return self;
}

-(void)initSubViews
{
    [self setItemColumnsAndRows];
    if(isPad)
    {
        height = 100;
        width = 100;
        
        xPadding = 60;
        yPadding = 80;
    }
    else{
        height = 75;
        width = 75;
        if(self.frame.size.height<=480)
        {
            height = 50;
            width = 50;
        }
        
        xPadding = 20;
        yPadding = 60;
    }
    _itemsContainer = [UIScrollView new];
    [_itemsContainer setScrollEnabled:YES];
    [_itemsContainer setPagingEnabled:YES];
    _itemsContainer.showsHorizontalScrollIndicator = NO;
    _itemsContainer.showsVerticalScrollIndicator = NO;
    _itemsContainer.delegate = self;
    [self addSubview:_itemsContainer];
    
    [_itemsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self.mas_width);
    }];
    [self layoutItems];
    
}


-(void)layoutItems
{
    
    int nCounter = 0;
    int perPageCount = Hcount*Vcount;
    int nCurrentRow = 1;
    int maxIndex = 0;
    int totalPage = ceil((float)[self.items count]/perPageCount);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *HViewsArrays = [[NSMutableArray alloc] init];
    NSMutableArray *VViewsArrays = [[NSMutableArray alloc] init];
    if (totalPage> currentPage+1 && [self.items count] >= perPageCount) {
        maxIndex = perPageCount;
    }
    else
    {
        maxIndex = (int)[self.items count];
    }
    
    for (int i = perPageCount*currentPage; i< maxIndex; i++)
    {
        
        ZFMenuItem *item = _items[i];
        
        item.delegate = self;
        item.tag = nCounter;
        [item layoutItem];
        [self addSubview:item];
        
        
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_lessThanOrEqualTo(CGSizeMake(width, height));
        }];
        
        
        if (maxIndex - currentPage*perPageCount < Hcount){
            /*不足一行 for example:
             |*|   or |*  *|
             */
            //是否是居中等距排列
            if(self.bCenter)
            {
                [array addObject:item];
                if (nCounter == maxIndex -1) {
                    [HViewsArrays insertObject:[array copy] atIndex:0];
                    [array removeAllObjects];
                }
                
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).offset(30);
                }];
            }
            else
            {
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).offset(30);
                    make.left.equalTo(nCounter <=0 ? @30:((UIView*)_items[perPageCount*currentPage+ nCounter-1]).mas_right).offset(xPadding);
                    
                }];
            }
            
        }
        else if(maxIndex >= Hcount && maxIndex % Hcount == 0 && ceil((float)maxIndex/ Hcount) != Vcount) //整行
            
        {
            /*整行 for example:
             |*  *  *|   or |*  *   *| or |*  *   *|
             |*  *   *|    |*  *   *|
             |*  *   *|
             */
            
            int row = ceil((float)(nCounter+1)/Hcount);
            if (nCurrentRow == row) {
                [array addObject:item];
                
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (row <= 1) {
                        make.top.equalTo(self.mas_top).offset(30);
                    }
                    else
                    {
                        make.top.equalTo(((UIView*)_items[perPageCount*currentPage + (row-1)* Hcount -1]).mas_bottom).offset(yPadding);
                    }
                    
                    
                }];
                
            }
            
            if (nCounter+1 == Hcount*row) {
                [HViewsArrays insertObject:[array copy] atIndex:row-1];
                
                [_items[perPageCount*currentPage + (row-1)*Hcount] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(HViewsArrays[row-1]);
                }];
                nCurrentRow++;
                [array removeAllObjects];
            }
        }
        else
        {
            /*非整列 for example:
             |*  *  *|   or |*  *  *| or |*  *   *|
             |*  *|         |*|          |*  *   *|
             |*|
             */
            NSMutableArray *vItem = [[NSMutableArray alloc] init];
            //第一种情况 不满列（无需等间距排列）
            int rows = ceil((float) maxIndex/Hcount);
            int column = (int)nCounter %Hcount;
            
            if (rows != Vcount) {
                int row = ceil((float)(nCounter+1)/Hcount);
                if (nCurrentRow == row) {
                    
                    
                    [array addObject:item];
                    
                    if (column == Hcount-1) {
                        [HViewsArrays insertObject:[array copy] atIndex:row-1];
                        
                        [_items[ perPageCount*currentPage + (row-1)*Hcount] mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(HViewsArrays[row-1]);
                        }];
                        [array removeAllObjects];
                    }
                    
                    [_items[perPageCount*currentPage + nCounter] mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (row <= 1) {
                            make.top.equalTo(self.mas_top).offset(30);
                        }
                        else{
                            make.top.equalTo(((UIView*)_items[perPageCount*currentPage +(row-2) *Hcount +column]).mas_bottom).offset(yPadding);
                        }
                        
                        
                        make.left.equalTo(((UIView*)_items[perPageCount*currentPage + column]).mas_left);
                    }];
                    
                    
                }
                
                if (nCounter+1 == Hcount*row)  nCurrentRow++;
                
            }
            //第二种情况，满列（等间距排列）
            else{
                
                int row = ceil((float)(nCounter+1)/Hcount);
                if (nCurrentRow == row) {
                    [array addObject:item];
                    
                }
                
                if (nCounter+1 == Hcount*row) {
                    [HViewsArrays insertObject:[array copy] atIndex:row-1];
                    
                    [_items[perPageCount*currentPage + (row-1)*Hcount] mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(HViewsArrays[row-1]);
                    }];
                    nCurrentRow++;
                    [array removeAllObjects];
                }
                //========================
                
                if ([VViewsArrays count] < Hcount)
                {
                    [vItem addObject:item];
                    [VViewsArrays insertObject:[vItem copy] atIndex:column];
                }
                else{
                    NSArray *views =[VViewsArrays objectAtIndex:column];
                    if (views == nil) {
                        [vItem addObject:item];
                        [VViewsArrays insertObject:[vItem copy] atIndex:column];
                    }
                    else{
                        NSMutableArray *vviews = [views mutableCopy];
                        [vviews addObject:item];
                        [VViewsArrays replaceObjectAtIndex:column withObject:vviews];
                        
                    }
                    
                }
            }
            
        }
        nCounter ++;
        
    }
    
    for (int i = 0;i<[VViewsArrays count]; i++) {
        
        
        if ([[VViewsArrays objectAtIndex:i] count] != Vcount) {
            break;
        }
        [_items[perPageCount*currentPage + i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(VViewsArrays[i]);
        }];
        [self distributeSpacingVerticallyWith:[[VViewsArrays objectAtIndex:i] copy]];
    }
    
    for (int i = 0;i<[HViewsArrays count]; i++) {
        [self distributeSpacingHorizontallyWith:[[HViewsArrays objectAtIndex:i] copy]];
    }
    
    _pageControl = [UIPageControl new];
    if (totalPage > 1) {
        _pageControl.backgroundColor = [UIColor lightGrayColor];
        _pageControl.numberOfPages = totalPage;
        _pageControl.currentPage = 0;
        //增加事件
        [_pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width,20));
            make.centerX.equalTo(self);
        }];
    }
    
    [_itemsContainer setContentSize:CGSizeMake(self.frame.size.width*totalPage, self.frame.size.height)];
    
}

#pragma mark - 更新约束
- (void)updateConstraints {
    [super updateConstraints];
    
    int totalPage = ceil((float)[self.items count]/(Hcount*Vcount));
    if (self.viewWidth == self.frame.size.width) {
        
    }
    else
    {
        [self setItemColumnsAndRows];
        _itemsContainer = [UIScrollView new];
        [_itemsContainer setScrollEnabled:YES];
        [_itemsContainer setPagingEnabled:YES];
        _itemsContainer.showsHorizontalScrollIndicator = NO;
        _itemsContainer.delegate = self;
        
        [self addSubview:_itemsContainer];
        
        [_itemsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [_itemsContainer setContentSize:CGSizeMake(self.frame.size.width*totalPage, self.frame.size.height)];
        
        //调整布局
        [self layoutItems];
        self.viewWidth = self.frame.size.width;
        self.viewHeight = self.frame.size.height;
        
    }
    
}

-(void) setItemColumnsAndRows
{
    if (self.frame.size.width > self.frame.size.height) {
        if(isPad)
        {
            Hcount = 5; //每列个数
            Vcount = 3; //每行个数
        }
        else{
            Hcount = 4; //每列个数
            Vcount = 3; //每行个数
        }
        
    }
    else
    {
        if(isPad)
        {
            Hcount = 3; //每列个数
            Vcount = 5; //每行个数
        }
        else{
            Hcount = 3; //每列个数
            Vcount = 4; //每行个数
        }
        
    }
}
#pragma mark - 等距排列
//横向等间距排列
- (void) distributeSpacingHorizontallyWith:(NSArray*)views
{
    if ([views count] <=0) {
        return;
    }
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0).priorityLow();
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
    }];
    
}

//纵向等间距排列
- (void) distributeSpacingVerticallyWith:(NSArray*)views
{
    if ([views count] <=0) {
        return;
    }
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

#pragma mark - scrollview delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _itemsContainer.frame.size.width;
    int page = 0;
    int totalPage = ceil((float)[self.items count]/(Hcount *Vcount));
    if (totalPage <=1) {
        return;
    }
    page = floor((_itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"page:%d",page);
    for (ZFMenuItem *item in self.items)
    {
        if (currentPage == page) {
            return;
        }
        
        [item removeFromSuperview];
    }
    if (currentPage !=page) {
        
        currentPage = page;
        
        [_itemsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self layoutItems];
        
    }
    currentPage = page;
    _pageControl.currentPage = page;
}

#pragma mark -  menuItemDelegate
- (void)launch:(int)tag viewController:(UIViewController *)viewController
{
    
    if([self.delegate respondsToSelector:@selector(launch:viewController:)]){
        [self.delegate launch:tag viewController:viewController];
    }
}
#pragma mark - pagecontrol value change
-(void) valueChange:(id) sender
{
    UIPageControl * pagecontrol = (UIPageControl *) sender;
    
    for (ZFMenuItem *item in self.items)
    {
        if (currentPage == (int)pagecontrol.currentPage) {
            return;
        }
        
        [item removeFromSuperview];
    }
    currentPage = (int)pagecontrol.currentPage;
    [self layoutItems];
    _pageControl.currentPage = currentPage;
}

@end

