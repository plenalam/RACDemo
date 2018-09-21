//
//  RACCommandViewController.m
//  RACDemo
//
//  Created by gxx_mobile on 2018/9/18.
//  Copyright © 2018年 plena. All rights reserved.
//

#import "RACCommandViewController.h"

@interface RACCommandViewController (){
    MBProgressHUD* hud;
    RACCommand *command;
}
@property(nonatomic,strong)UIButton * createRACCommondBtn;
@property(nonatomic,strong)UIButton * executeRACCommondBtn;

@end

@implementation RACCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self codeAddSubView];
    [self setUpView];
}

-(void)createRACCommond{
    //必须强引用
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //至少要return[RACSignal empty]
        //创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:(@"data")];
            //RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        //返回的id是个信号,所以还要订阅一次
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        
    }];
    
    //可以直接拿到信号的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"switchToLatest %@",x);
    }];
    
    //监听是否执行完毕
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完成");
        }
        
    }];
}

-(void)executeRACCommond{
    [command execute:@1];
}

-(void)codeAddSubView{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    _createRACCommondBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_createRACCommondBtn setTitle:@"create RACCommond" forState:UIControlStateNormal];
    [[self view]addSubview: _createRACCommondBtn];
    [_createRACCommondBtn sizeToFit];
    [_createRACCommondBtn addTarget:self action:@selector(createRACCommond) forControlEvents:UIControlEventTouchUpInside];
    
    _executeRACCommondBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_executeRACCommondBtn setTitle:@"execute RACCommond" forState:UIControlStateNormal];
    [[self view]addSubview: _executeRACCommondBtn];
    [_executeRACCommondBtn sizeToFit];
    [_executeRACCommondBtn addTarget:self action:@selector(executeRACCommond) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setUpView{
    [_createRACCommondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_executeRACCommondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createRACCommondBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}


@end
