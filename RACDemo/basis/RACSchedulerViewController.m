//// RACSchedulerViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/20.
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "RACSchedulerViewController.h"


@interface RACSchedulerViewController ()

@property (nonatomic,strong) UIButton * deliverOnBtn;
@property (nonatomic,strong) UIButton * subscribeOnBtn;
@property (nonatomic,strong) UIButton * deliverOnMainsubscribeOnNewBtn;

@end

@implementation RACSchedulerViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response

-(void)createRACScheduler{
    //主线程
    [RACScheduler mainThreadScheduler];
    //当前线程
    [RACScheduler currentScheduler];
    
    /// schdeuler 有四种优先级,对用GCD里的四种优先级
    /// RACSchedulerPriorityHigh       - High priority.
    /// RACSchedulerPriorityDefault    - Default priority.
    /// RACSchedulerPriorityLow        - Low priority.
    /// RACSchedulerPriorityBackground - Background priority.
    [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
    [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:@"aaa"];
  
    //优先级为RACSchedulerPriorityDefault
    [RACScheduler scheduler];
}

//指定接收器
- (void)deliverOn{
    RACSubject *subject = [RACSubject subject];
    [[subject deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
        NSLog(@"[RACScheduler scheduler]subscribeNext Thread:%@ value:%@",[NSThread currentThread],x);
    }completed:^{
        NSLog(@"[RACScheduler scheduler]completed Thread:%@",[NSThread currentThread]);
    }];
    [subject sendNext:@"scheduler"];
    [subject sendCompleted];
    
    RACSubject *subject2 = [RACSubject subject];
    [[subject2 deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"[RACScheduler mainThreadScheduler]subscribeNext Thread:%@ value:%@",[NSThread currentThread],x);
    }completed:^{
        NSLog(@"[RACScheduler mainThreadScheduler]completed Thread:%@",[NSThread currentThread]);
    }];
    [subject2 sendNext:@"main"];
    [subject2 sendCompleted];
}

- (void)subscribeOn{
    RACSignal  *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"sendNext Thread:%@",[NSThread currentThread]);
        [subscriber sendNext:@"next"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }] ;
    [[signal subscribeOn:[RACScheduler scheduler]
      ]subscribeNext:^(id x) {
        NSLog(@"subscribeNext Thread:%@",[NSThread currentThread]);
    }completed:^{
        NSLog(@"completed Thread:%@",[NSThread currentThread]);
    }];
}

- (void) deliverOnMainsubscribeOnNew{
    RACSignal  *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"sendNext Thread:%@",[NSThread currentThread]);
        //耗时操作
        [subscriber sendNext:@"next"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }] ;
    //signal.deliverOnMainThread = signal deliverOn:[RACScheduler mainThreadScheduler]
    [[signal.deliverOnMainThread
      subscribeOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         //回主线程更新UI
         NSLog(@"subscribeNext Thread:%@",[NSThread currentThread]);
     }completed:^{
         NSLog(@"completed Thread:%@",[NSThread currentThread]);
     }];
}

#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}

-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    self.deliverOnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.deliverOnBtn setTitle:@"deliverOn" forState:UIControlStateNormal];
    [[self view]addSubview:  self.deliverOnBtn];
    [self.deliverOnBtn sizeToFit];
    [self.deliverOnBtn addTarget:self action:@selector(deliverOn) forControlEvents:UIControlEventTouchUpInside];
    
    self.subscribeOnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.subscribeOnBtn setTitle:@"subscribeOn" forState:UIControlStateNormal];
    [[self view]addSubview:  self.subscribeOnBtn];
    [self.subscribeOnBtn sizeToFit];
    [self.subscribeOnBtn addTarget:self action:@selector(subscribeOn) forControlEvents:UIControlEventTouchUpInside];
    
    self.deliverOnMainsubscribeOnNewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.deliverOnMainsubscribeOnNewBtn setTitle:@"deliverOn Main subscribeOn New" forState:UIControlStateNormal];
    [[self view]addSubview:  self.deliverOnMainsubscribeOnNewBtn];
    [self.deliverOnMainsubscribeOnNewBtn sizeToFit];
    [self.deliverOnMainsubscribeOnNewBtn addTarget:self action:@selector(deliverOnMainsubscribeOnNew) forControlEvents:UIControlEventTouchUpInside];
}

-(void)layoutPageSubviews{
    [ self.deliverOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [ self.subscribeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deliverOnBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [ self.deliverOnMainsubscribeOnNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subscribeOnBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
