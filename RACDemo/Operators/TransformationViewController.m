//
//  TransformationViewController.m
//  RACDemo
//
//  Created by gxx_mobile on 2018/9/19.
//  Copyright © 2018年 plena. All rights reserved.
//

#import "TransformationViewController.h"

@interface TransformationViewController ()

@property (nonatomic,strong) UIButton * bufferBtn;
@property (nonatomic,strong) UIButton * mapBtn;
@property (nonatomic,strong) UIButton * flatMapBtn;
@property (nonatomic,strong) UIButton * scanBtn;


@end

@implementation TransformationViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self layoutViews];
    [self setTitle:@"Transformation"];
}

#pragma mark - Observables

//把Observable的每项数据执行变换操作再发射出来
-(void)MapOperators{
    RACSubject *subject = [RACSubject subject];
    [subject map:^id(id value) {
        return [NSString stringWithFormat:@"map%@",value];
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"after map:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
}

//从Observable转换到另一个或多个Observable
//只要有一个error,就不会返回剩下的值
-(void)FlatMapOperators{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectC = [RACSubject subject];
    [[[subjectA flattenMap:^RACStream *(id value) {
        NSLog(@"1: %@",value);
        if ([value isEqualToString:@"A"]) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@"B"];
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"disposable");
                }];
            }];
        }
        return [RACSignal error:[[NSError alloc] initWithDomain:@"a.error" code:(NSInteger)1 userInfo:@{}]];
    }] flattenMap:^RACStream *(id value) {
           NSLog(@"2: %@",value);
        return subjectC;
    }] subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    } error:^(NSError *error) {
         NSLog(@"error:%@",[error localizedDescription]);
    } completed:^{
         NSLog(@"completed");
    }];
    [subjectA sendNext:@"A"];
    [subjectC sendNext:@"C"];
    [subjectC sendCompleted];
}

//把Buffer分成缓冲区
//每到一次时间点,把缓冲区里所有数据发出去
//调用complete会把缓冲区剩下的所有内容都发出去,无论是否有到时间
//接收到的id是RACTuple类型
-(void)BufferOperators{
    RACSubject *subject = [RACSubject subject];
    [[subject bufferWithTime:3 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"buffer subscribeNextf%@:",x);
    } completed:^{
        NSLog(@"buffer complete");
    }];

    [subject sendNext:@"A"];
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subject sendNext:@"B"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
        [subject sendNext:@"C"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subject sendNext:@"D"];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:7 schedule:^{
        [subject sendNext:@"E"];
        [subject sendCompleted];
    }];
    
}

-(void)ScanOperators{
    RACSubject *subject = [RACSubject subject];
    [[subject scanWithStart:@"A" reduce:^id(NSString *running, NSString * next) {
        NSLog(@"scan running: %@ next: %@",running,next);
        return [NSString stringWithFormat:@"%@%@",running,next];
    }] subscribeNext:^(id x) {
         NSLog(@"subscribeNext: %@",x);
    }];
    [subject sendNext:@"B"];
        [subject sendNext:@"C"];
        [subject sendNext:@"D"];
}

#pragma mark - UI
-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    _mapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_mapBtn setTitle:@"map" forState:UIControlStateNormal];
    [[self view]addSubview: _mapBtn];
    [_mapBtn sizeToFit];
    [_mapBtn addTarget:self action:@selector(MapOperators) forControlEvents:UIControlEventTouchUpInside];
    
    _flatMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_flatMapBtn setTitle:@"flattenMap" forState:UIControlStateNormal];
    [[self view]addSubview: _flatMapBtn];
    [_flatMapBtn sizeToFit];
    [_flatMapBtn addTarget:self action:@selector(FlatMapOperators) forControlEvents:UIControlEventTouchUpInside];
    
    _bufferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bufferBtn setTitle:@"buffer" forState:UIControlStateNormal];
    [[self view]addSubview: _bufferBtn];
    [_bufferBtn sizeToFit];
    [_bufferBtn addTarget:self action:@selector(BufferOperators) forControlEvents:UIControlEventTouchUpInside];
    
    _scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_scanBtn setTitle:@"scan" forState:UIControlStateNormal];
    [[self view]addSubview: _scanBtn];
    [_scanBtn sizeToFit];
    [_scanBtn addTarget:self action:@selector(ScanOperators) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)layoutViews{
    [_mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [_flatMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mapBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [_bufferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_flatMapBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bufferBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
