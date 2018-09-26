////AFNetworkingViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/25. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "AFNetworkingViewController.h"
#import "AFNetworkingRequest.h"

@interface AFNetworkingViewController ()
@property (nonatomic,strong) UIButton *getBtn;
@property (nonatomic,strong) MBProgressHUD* hud;
@end

@implementation AFNetworkingViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response

-(void)testGet{
    [[[AFNetworkingRequest sharedInstance]  rac_GetWithUrl:@"http://api.map.baidu.com/place/v2/search" params:@{@"query":@"ATM机",
                                                                                                                @"tag":@"银行",
                                                                                                                @"region":@"北京",
                                                                                                                @"output":@"json",
                                                                                                                @"ak":@"ZNml7OlE918HnkFcm2wT1W92V4fvXkLr"
                                                                                                                }] subscribeNext:^(id x) {
        [self showToast:x];
    } error:^(NSError *error) {
        [self showToast:[error localizedDescription]];
    }];
}

-(void)mutiGet{
    [[[[[AFNetworkingRequest sharedInstance] rac_GetWithUrl:@"http://api.map.baidu.com/place/v2/search" params:@{@"query":@"ATM机",
                                                                                                                 @"tag":@"银行",
                                                                                                                 @"region":@"北京",
                                                                                                                 @"output":@"json",
                                                                                                                 @"ak":@"ZNml7OlE918HnkFcm2wT1W92V4fvXkLr"
                                                                                                                 }]
       flattenMap:^RACStream *(id value) {
           return [[AFNetworkingRequest sharedInstance]rac_GetWithUrl:@"http://api.map.baidu.com/place/v2/search" params:@{}];
       }] flattenMap:^RACStream *(id value) {
           return [[AFNetworkingRequest sharedInstance]rac_GetWithUrl:@"http://api.map.baidu.com/place/v2/search" params:@{}];
       }] subscribeNext:^(id x) {
           
       } error:^(NSError *error) {
           
       }];
    
}

#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}
# pragma mark setupViews
-(void)setupViews{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    self.getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.getBtn setTitle:@"get" forState:UIControlStateNormal];
    [self.getBtn sizeToFit];
    [[self.getBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self testGet];
    }];
    [self.view addSubview:self.getBtn];
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
}

-(void)showToast:(id)content{
    if(!self.hud){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [[self.hud label]setText:content];
    [self.hud setMode:MBProgressHUDModeText];
    [self.hud showAnimated:true];
    [self.hud hideAnimated:YES afterDelay:2.f];
}

@end
