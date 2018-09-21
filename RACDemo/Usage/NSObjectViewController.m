////NSObjectViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/21. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "NSObjectViewController.h"

@interface NSObjectViewController ()
@property(nonatomic,strong)RACSignal* intervalDisposable;
@end
@implementation NSObjectViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)sendNSNotification{
    //不需要在dealloc里注销
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidEndEditingNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
}

- (void)interval{
    self.intervalDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
    
    }];
}

#pragma mark - IBActions/Event Response

#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}
# pragma mark setupViews
-(void)setupViews{
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
}

@end
