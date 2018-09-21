//
//  RACSignalViewController.m
//  RACDemo
//
//  Created by gxx_mobile on 2018/9/18.
//  Copyright © 2018年 plena. All rights reserved.
//

#import "RACSignalViewController.h"


@interface RACSignalViewController (){
    
    MBProgressHUD* hud;
    RACSignal * signal;
}

@property(nonatomic,strong)UIButton* creatRACSignalBtn;
@property(nonatomic,strong)UIButton* subscribeRACSignalBtn;
@property(nonatomic,strong)UIButton* blockRACSignalBtn;

@end

@implementation RACSignalViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"RACSignal"];
    [self codeAddSubView];
    [self setUpView];
}


#pragma mark - RAC Function
- (void)creatRACSiganl{
    //创建一个信号
    signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"next"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }];
    
    
}

-(void)subscribeSignal{
    [signal subscribeNext:^(id  _Nullable x) {
        [self showToast: x];
    }];
    [signal subscribeCompleted:^{
        NSLog(@"subscribeCompleted");
    }];
}

-(void)showToast:(id)content{
    if(!hud){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [[hud label]setText:content];
    [hud setMode:MBProgressHUDModeText];
    [hud showAnimated:true];
    [hud hideAnimated:YES afterDelay:2.f];
}


#pragma mark - UI
-(void)codeAddSubView{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    _creatRACSignalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_creatRACSignalBtn setTitle:@"create RACSiganl" forState:UIControlStateNormal];
    [[self view]addSubview: _creatRACSignalBtn];
    [_creatRACSignalBtn sizeToFit];
    [_creatRACSignalBtn addTarget:self action:@selector(creatRACSiganl) forControlEvents:UIControlEventTouchUpInside];
    
    _subscribeRACSignalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_subscribeRACSignalBtn setTitle:@"subscribe RACSignal" forState:UIControlStateNormal];
    [[self view]addSubview: _subscribeRACSignalBtn];
    [_subscribeRACSignalBtn sizeToFit];
    [_subscribeRACSignalBtn addTarget:self action:@selector(subscribeSignal) forControlEvents:UIControlEventTouchUpInside];
    
    _blockRACSignalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_blockRACSignalBtn setTitle:@"block RACSignal" forState:UIControlStateNormal];
    [[self view]addSubview: _blockRACSignalBtn];
    [_blockRACSignalBtn sizeToFit];
    [_blockRACSignalBtn addTarget:self action:@selector(subscribeSignal) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [[_blockRACSignalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:@"call from block"];
    }];
    
}

-(void)setUpView{
    [_creatRACSignalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_subscribeRACSignalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creatRACSignalBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_blockRACSignalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subscribeRACSignalBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}
@end
