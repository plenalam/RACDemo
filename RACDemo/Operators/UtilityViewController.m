////UtilityViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/20. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "UtilityViewController.h"

@interface UtilityViewController ()
@property (nonatomic,strong) UIButton *delayBtn;
@property (nonatomic,strong) UIButton *timeoutBtn;
@property (nonatomic,strong) UIButton *retryBtn;

@property (nonatomic,strong) NSString *sendData;
@end

@implementation UtilityViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response

// 延迟接收数据
- (void)delay{
    self.sendData = @"A";
    RACSubject *subject = [RACSubject subject];
    [[subject delay:2] subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }];
    [subject sendNext:self.sendData];
    __weak typeof(self) weakSelf = self;
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        __strong typeof(weakSelf) self = weakSelf;
        [self setSendData:@"B"];
        NSLog(@"change send data to:%@",[self sendData]);
    }];
}

- (void)timeout{
    RACSubject *subject = [RACSubject subject];
    [[subject timeout:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
             NSLog(@"subscribeNext:%@",x);
    } error:^(NSError *error) {
         NSLog(@"error:%@",[error localizedDescription]);
    } completed:^{
        NSLog(@"completed");
    }];
    [subject sendNext:@"A"];
    
}

- (void)retry{
    __block NSInteger i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        i++;
        NSLog(@"subscribe times:%d",i);
        if (i > 3) {
            [subscriber sendNext:@"A"];
        }else{
            [subscriber sendError:nil];
        }
        return nil;
    }] retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext:%@",x);
    }error:^(NSError * _Nullable error) {
        NSLog(@"NSError:%@",error);
    }];
}

#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}
# pragma mark setupViews
-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    self.delayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.delayBtn setTitle:@"delay" forState:UIControlStateNormal];
    [[self view]addSubview: self.delayBtn];
    [self.delayBtn sizeToFit];
    [self.delayBtn addTarget:self action:@selector(delay) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.timeoutBtn setTitle:@"timeout" forState:UIControlStateNormal];
    [[self view]addSubview: self.timeoutBtn];
    [self.timeoutBtn sizeToFit];
    [self.timeoutBtn addTarget:self action:@selector(timeout) forControlEvents:UIControlEventTouchUpInside];
    
    self.retryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.retryBtn setTitle:@"retry" forState:UIControlStateNormal];
    [[self view]addSubview: self.retryBtn];
    [self.retryBtn sizeToFit];
    [self.retryBtn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.delayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.timeoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.delayBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeoutBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
