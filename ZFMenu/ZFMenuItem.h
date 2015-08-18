//
//  ZFMenuItem.h
//  ZFMenu
//
//  Created by macOne on 15/8/18.
//  Copyright (c) 2015年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"


@protocol ZFMenuItemDelegate <NSObject>

- (void)launch:(int)index viewController:(UIViewController *)viewController;
@end

@interface ZFMenuItem : UIView

@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *imageName;
@property(nonatomic,strong) NSString *selectedImageName;
@property(nonatomic,strong) UIViewController *viewController;

@property (nonatomic, assign) id <ZFMenuItemDelegate> delegate;

+ (id) initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString*)selectedImageName viewController:(UIViewController *)viewController;
-(void)layoutItem;

-(void)setBadgeText:(NSString *)text;
-(void)setCustomBadge:(CustomBadge *)customBadge;

@end
