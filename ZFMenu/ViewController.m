//
//  ViewController.m
//  ZFMenu
//
//  Created by macOne on 15/8/18.
//  Copyright (c) 2015年 WZF. All rights reserved.
//

#import "ViewController.h"
#import "ZFMenuItem.h"
#import "ZFMenuView.h"


@interface ViewController ()

@property (nonatomic,strong)  ZFMenuView *iconMenuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[ZFMenuItem initWithTitle:@"item1"
                                     imageName:@"usedes_normal"
                             selectedImageName:@"usedes_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item2"
                                     imageName:@"about_normal"
                             selectedImageName:@"about_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item3"
                                     imageName:@"protect_normal"
                             selectedImageName:@"protect_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item4"
                                     imageName:@"logo_normal"
                             selectedImageName:@"logo_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item5"
                                     imageName:@"exchange_normal"
                             selectedImageName:@"exchange_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item6"
                                     imageName:@"logout_normal"
                             selectedImageName:@"logout_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item7"
                                     imageName:@"protect_normal"
                             selectedImageName:@"protect_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item8"
                                     imageName:@"logo_normal"
                             selectedImageName:@"logo_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item9"
                                     imageName:@"exchange_normal"
                             selectedImageName:@"exchange_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item10"
                                     imageName:@"usedes_normal"
                             selectedImageName:@"usedes_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item11"
                                     imageName:@"about_normal"
                             selectedImageName:@"about_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item12"
                                     imageName:@"logo_normal"
                             selectedImageName:@"logo_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item13"
                                     imageName:@"exchange_normal"
                             selectedImageName:@"exchange_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item14"
                                     imageName:@"protect_normal"
                             selectedImageName:@"protect_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item15"
                                     imageName:@"about_normal"
                             selectedImageName:@"about_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item16"
                                     imageName:@"logo_normal"
                             selectedImageName:@"logo_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item17"
                                     imageName:@"exchange_normal"
                             selectedImageName:@"exchange_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item18"
                                     imageName:@"logout_normal"
                             selectedImageName:@"logout_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item19"
                                     imageName:@"exchange_normal"
                             selectedImageName:@"exchange_normal"
                                viewController:nil]];
    [items addObject:[ZFMenuItem initWithTitle:@"item20"
                                     imageName:@"logout_normal"
                             selectedImageName:@"logout_normal"
                                viewController:nil]];
    
     _iconMenuView = [ZFMenuView initWithFrame:self.view.frame title:@"系统设置" items:items];
    [self.view addSubview:_iconMenuView];
    
    [[items objectAtIndex:0] setBadgeText:@"10"];
    [[items objectAtIndex:1] setBadgeText:@"1000"];
    [[items objectAtIndex:2] setBadgeText:@"10"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_iconMenuView) {
        [_iconMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_iconMenuView setNeedsUpdateConstraints];
        
    }
}

#pragma mark -翻转 自动
//reason：  登录界面不允许旋转
- (BOOL) shouldAutorotate {
    return YES;
}

@end
