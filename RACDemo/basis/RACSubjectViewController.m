//
//  RACSubjectViewController.m
//  RACDemo
//
//  Created by gxx_mobile on 2018/9/18.
//  Copyright © 2018年 plena. All rights reserved.
//  RACSubject自己能充当信号,又能发送信号
//

#import "RACSubjectViewController.h"

@interface RACSubjectViewController (){
      MBProgressHUD* hud;
}
@property(nonatomic,strong)UIButton* creatRACSubjectBtn;
@property(nonatomic,strong)UIButton* createRACReplaySubjectBtn;
@end


@implementation RACSubjectViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem]setTitle:@"RACSubject"];
    [self codeAddSubView];
    [self setUpView];
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

-(void)createRACSubject{
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"1 subscribe:%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"2 subscribe:%@",x);
    }];    
    [subject sendNext:@"1"];
}

//可以先发送信号再订阅
-(void)createRACReplaySubject{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];

    [replaySubject subscribeNext:^(id x) {
        NSLog(@"1 subscribe%@",x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"2 subscribe%@",x);
    }];
}

-(void)codeAddSubView{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    _creatRACSubjectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_creatRACSubjectBtn setTitle:@"create RACSiganl" forState:UIControlStateNormal];
    [[self view]addSubview: _creatRACSubjectBtn];
    [_creatRACSubjectBtn sizeToFit];
    [_creatRACSubjectBtn addTarget:self action:@selector(createRACSubject) forControlEvents:UIControlEventTouchUpInside];
    
    _createRACReplaySubjectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_createRACReplaySubjectBtn setTitle:@"create RACReplaySubject" forState:UIControlStateNormal];
    [[self view]addSubview: _createRACReplaySubjectBtn];
    [_createRACReplaySubjectBtn sizeToFit];
    [_createRACReplaySubjectBtn addTarget:self action:@selector(createRACReplaySubject) forControlEvents:UIControlEventTouchUpInside];

}
-(void)setUpView{
    [_creatRACSubjectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_createRACReplaySubjectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creatRACSubjectBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
