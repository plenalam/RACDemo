////UIKitsViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/20. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "UIKitsViewController.h"

@interface UIKitsViewController ()

@property (nonatomic,strong) MBProgressHUD* hud;
@property (nonatomic,strong) UITextField *inputA;
@property (nonatomic,strong) NSString *modelStr;
@property (nonatomic,strong) UIButton *changeStrBtn;
@property (nonatomic,strong) UITextField *inputB;


@end

@implementation UIKitsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
    [self setUpUISignal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setUpUISignal{
    //搜索框有输入时发送请求,但不要发送的太频繁
    [[[self.inputA rac_textSignal] throttle:2] subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@",x);
    }];
    
    //按钮点击事件
    __weak typeof(self) weakSelf = self;
    [[self.changeStrBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong typeof(weakSelf) self = weakSelf;
        [self showToast:self.modelStr];
        self.modelStr = @"AAA";
    }];
    //双向绑定
    RACChannelTo(self.inputA,text) = RACChannelTo(self,self.modelStr);
    //双向绑定的原理是KVO,但是有时候UIKit对属性的复写会导致KVO不生效,额外添加绑定
    [self.inputA.rac_newTextChannel subscribe:RACChannelTo(self,self.modelStr)];
    
    

    //当两个文本输入框都有值的时候,按钮才可点击
    RAC(self.changeStrBtn, enabled) = [RACSignal combineLatest:@[self.inputA.rac_textSignal, self.inputB.rac_textSignal]
                                                        reduce:^id _Nullable(NSString * username, NSString * password){
        
        return @(username.length && password.length);
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

#pragma mark - IBActions/Event Response



#pragma mark - UI
- (void)setUpUIs{
    [self setupViews];
    [self layoutPageSubviews];
}
# pragma mark setupViews
-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    self.inputA = [[UITextField alloc]init];
    [self.inputA setBackgroundColor:[UIColor lightGrayColor]];
    [self.inputA setBorderStyle:UITextBorderStyleRoundedRect];
    [self.inputA setPlaceholder:@"inputA"];
    [[self view]addSubview:self.inputA];
    
    self.inputB = [[UITextField alloc]init];
    [self.inputB setBackgroundColor:[UIColor lightGrayColor]];
    [self.inputB setBorderStyle:UITextBorderStyleRoundedRect];
    [self.inputB setPlaceholder:@"inputB"];
    [[self view]addSubview:self.inputB];
    
    self.changeStrBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.changeStrBtn setTitle:@"change value: AAA" forState:UIControlStateNormal];
    [self.changeStrBtn sizeToFit];
    [self.view addSubview:self.changeStrBtn];
    
   
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.inputA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
    
    [self.inputB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputA.mas_bottom).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
    
    [self.changeStrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputB.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}


@end
