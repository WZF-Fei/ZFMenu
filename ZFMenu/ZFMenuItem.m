//
//  ZFMenuItem.m
//  ZFMenu
//
//  Created by macOne on 15/8/18.
//  Copyright (c) 2015年 WZF. All rights reserved.
//

#import "ZFMenuItem.h"

@interface ZFMenuItem()

@property(nonatomic,strong)CustomBadge *badge;

@end

@implementation ZFMenuItem

@synthesize tag;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (id) initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString*)selectedImageName viewController:(UIViewController *)viewController
{
    ZFMenuItem *tmpInstance = [[ZFMenuItem alloc] initWithTitle:title imageName:imageName selectedImageName:selectedImageName viewController:viewController];
    return tmpInstance;
}


-(id) initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString*)selectedImageName viewController:(UIViewController *)viewController
{
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.imageName = imageName;
    self.selectedImageName = selectedImageName;
    self.viewController = viewController;
    
    [self layoutItem];
    
    return self;
}

-(void)layoutItem
{
    if (!self.imageName) {
        return;
    }
    //    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    
    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    icon.tag = tag;
    [icon setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
    if (self.selectedImageName) {
        [icon setImage:[UIImage imageNamed:self.selectedImageName] forState:UIControlStateSelected];
    }
    [icon addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    self.userInteractionEnabled = YES;
    [self addSubview:icon];
    
    
    UILabel *itemLabel = [UILabel new];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.font = [UIFont boldSystemFontOfSize:14];
    itemLabel.text = _title;
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.numberOfLines = 2;
    [self addSubview:itemLabel];
    
    if (self.badge) {
        
        [self addSubview:self.badge];
        [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(self.badge.bounds.size.width, self.badge.bounds.size.height));
        }];
        
    }
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom);
        make.centerX.equalTo(self);
        //项目特殊要求 5个占一行
        if(itemLabel.text.length == 5)
        {
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }
        else{
            make.size.mas_equalTo(CGSizeMake(70, 50));
        }
        
        //        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
}

-(void)clickIconButton:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if([self.delegate respondsToSelector:@selector(launch:viewController:)]){
        [self.delegate launch:tag viewController:_viewController];
    }
}


#pragma mark - 实现setter getter 方法

-(void)setBadgeText:(NSString *)text {
    if (text && [text length] > 0) {
        [self setBadge:[CustomBadge customBadgeWithString:text]];
    } else {
        if (self.badge) {
            [self.badge removeFromSuperview];
        }
        [self setBadge:nil];
    }
    [self layoutItem];
}

-(void)setCustomBadge:(CustomBadge *)customBadge {
    [self setBadge:customBadge];
    [self layoutItem];
}

@end
