//
//  ZFMenuView.h
//  ZFMenu
//
//  Created by macOne on 15/8/18.
//  Copyright (c) 2015年 WZF. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZFMenuItem.h"

@protocol ZFMenuViewDelegate <NSObject>

- (void)launch:(int)tag viewController:(UIViewController *)viewController;


@end

@interface ZFMenuView : UIView


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) id<ZFMenuViewDelegate> delegate;

@property (nonatomic,assign) BOOL bCenter;
@property  int Hcount;
@property  int Vcount;

+ (id) initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)menuItems;
-(void)layoutItems;

@end

