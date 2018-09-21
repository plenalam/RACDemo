////
// RACDemo 
// 
// Created by Plena on 2018/9/20. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "CombinationViewController.h"

@interface CombinationViewController ()
@property (nonatomic,strong) UIButton *concatBtn;
@property (nonatomic,strong) UIButton *combineBtn;
@property (nonatomic,strong) UIButton *zipBtn;
@property (nonatomic,strong) UIButton *mergeBtn;
@end

@implementation CombinationViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response

// 每条流来信号的时候,若其他流都有值,则发送信号
// 返回值为每条数据流最后获取的信号的集合
- (void) combine{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSignal * signal = [RACSignal combineLatest:@[subjectA,subjectB] reduce:^id(NSString *aValue, NSString *bValue){
        return [NSString stringWithFormat:@"combineA:%@ B:%@",aValue,bValue];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }completed:^{
        NSLog(@"completed");
    }] ;
    [subjectA sendNext:@"A1"];
    [subjectB sendNext:@"B1"];
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
       [subjectB sendNext:@"B2"];
       [subjectB sendNext:@"B3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subjectA sendNext:@"A2"];
        [subjectA sendNext:@"A3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
        [subjectA sendCompleted];
        [subjectB sendCompleted];
    }];
  
}



// 所有流都有新信号来的时候才更新
- (void) zip{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSignal * signal = [RACSignal zip:@[subjectA,subjectB] reduce:^id(NSString *aValue, NSString *bValue){
        return [NSString stringWithFormat:@"combineA:%@ B:%@",aValue,bValue];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }completed:^{
        NSLog(@"completed");
    }] ;
    [subjectA sendNext:@"A1"];
    [subjectB sendNext:@"B1"];
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [subjectB sendNext:@"B2"];
        [subjectB sendNext:@"B3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subjectA sendNext:@"A2"];
        [subjectA sendNext:@"A3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
        [subjectA sendCompleted];
        [subjectB sendCompleted];
    }];
}


// 先更新一条的信号,直到sendCompleted,再更新另一条流的信号
- (void) concat{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSignal * signal = [RACSignal concat:@[subjectA,subjectB]];
    [signal subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }completed:^{
        NSLog(@"completed");
    }] ;
    [subjectA sendNext:@"A1"];
    [subjectB sendNext:@"B1"];
    [subjectA sendNext:@"A2"];
    [subjectB sendNext:@"B2"];
    [subjectA sendNext:@"A3"];
    [subjectA sendCompleted];
    [subjectB sendNext:@"B3"];
    [subjectB sendCompleted];
}

// 按时间顺序合并到一条流
- (void)merge{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSignal * signal = [RACSignal merge:@[subjectA,subjectB]];
    [signal subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }completed:^{
        NSLog(@"completed");
    }] ;
    [subjectA sendNext:@"A1"];
    [subjectB sendNext:@"B1"];
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [subjectB sendNext:@"B2"];
        [subjectB sendNext:@"B3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subjectA sendNext:@"A2"];
        [subjectA sendNext:@"A3"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
        [subjectA sendCompleted];
        [subjectB sendCompleted];
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
    self.combineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.combineBtn setTitle:@"combine" forState:UIControlStateNormal];
    [[self view]addSubview:  self.combineBtn];
    [ self.combineBtn sizeToFit];
    [ self.combineBtn addTarget:self action:@selector(combine) forControlEvents:UIControlEventTouchUpInside];
    
    self.concatBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.concatBtn setTitle:@"concat" forState:UIControlStateNormal];
    [[self view]addSubview:  self.concatBtn];
    [ self.concatBtn sizeToFit];
    [ self.concatBtn addTarget:self action:@selector(concat) forControlEvents:UIControlEventTouchUpInside];
    
    self.zipBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.zipBtn setTitle:@"zip" forState:UIControlStateNormal];
    [[self view]addSubview:  self.zipBtn];
    [self.zipBtn sizeToFit];
    [self.zipBtn addTarget:self action:@selector(zip) forControlEvents:UIControlEventTouchUpInside];
    
    self.mergeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mergeBtn setTitle:@"merge" forState:UIControlStateNormal];
    [[self view]addSubview:  self.mergeBtn];
    [self.mergeBtn sizeToFit];
    [self.mergeBtn addTarget:self action:@selector(merge) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.combineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.concatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.combineBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.zipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.concatBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.mergeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zipBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
