////FilterViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/20. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "FilterViewController.h"

@interface FilterViewController ()
@property (nonatomic,strong) UIButton *throttleBtn;
@property (nonatomic,strong) UIButton *distinctBtn;
@property (nonatomic,strong) UIButton *filterBtn;

@end

@implementation FilterViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response
// 一段时间只接收一个信号
-(void)throttle{
    RACSubject *subject = [RACSubject subject];
    [[subject throttle:1] subscribeNext:^(id x) {
        NSLog(@"subscribeNext: %@",x);
    } completed:^{
        NSLog(@"completed");
    }];
    [subject sendNext:@"A"];
    [subject sendNext:@"B"];
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [subject sendNext:@"C"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
        [subject sendNext:@"D"];
        [subject sendCompleted];
    }];
}

- (void)distinct{
    RACSubject *subject = [RACSubject subject];
    [subject.distinctUntilChanged subscribeNext:^(id x) {
        NSLog(@"subscribeNext: %@",x);
    } completed:^{
        NSLog(@"completed");
    }];
    [subject sendNext:@"A"];
    [subject sendNext:@"A"];
    [subject sendNext:@"A"];
    [subject sendNext:@"B"];
    [subject sendNext:@"C"];
    [subject sendCompleted];
}

- (void)filter{
    RACSubject *subject = [RACSubject subject];
    [[subject filter:^BOOL(NSString *value) {
        return [value containsString:@"A"];
    }] subscribeNext:^(id x) {
        NSLog(@"subscribeNext: %@",x);
    } completed:^{
        NSLog(@"completed");
    }];
    [subject sendNext:@"A"];
    [subject sendNext:@"ABC"];
    [subject sendNext:@""];
    [subject sendNext:@"B"];
    [subject sendNext:@"AC"];
    [subject sendCompleted];
}


#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}
# pragma mark setupViews
-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    self.throttleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.throttleBtn setTitle:@"throttle" forState:UIControlStateNormal];
    [[self view]addSubview: self.throttleBtn];
    [self.throttleBtn sizeToFit];
    [self.throttleBtn addTarget:self action:@selector(throttle) forControlEvents:UIControlEventTouchUpInside];
    
    self.distinctBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.distinctBtn setTitle:@"distinct" forState:UIControlStateNormal];
    [[self view]addSubview: self.distinctBtn];
    [self.distinctBtn sizeToFit];
    [self.distinctBtn addTarget:self action:@selector(distinct) forControlEvents:UIControlEventTouchUpInside];
    
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.filterBtn setTitle:@"filter" forState:UIControlStateNormal];
    [[self view]addSubview: self.filterBtn];
    [self.filterBtn sizeToFit];
    [self.filterBtn addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.throttleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.distinctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.throttleBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distinctBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
