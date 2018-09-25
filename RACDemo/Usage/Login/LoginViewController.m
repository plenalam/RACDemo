////LoginViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/21. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic,strong) UITextField *usernameField;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) LoginViewModel *loginViewModel;
@property (nonatomic,strong) MBProgressHUD* hud;

@end

@implementation LoginViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
    _loginViewModel = [[LoginViewModel alloc]init];
    [self setUpUISignal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.usernameField = [[UITextField alloc]init];
    [self.usernameField setBackgroundColor:[UIColor lightGrayColor]];
    [self.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.usernameField setPlaceholder:@"UserName"];
    [[self view]addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc]init];
    [self.passwordField setBackgroundColor:[UIColor lightGrayColor]];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.passwordField setPlaceholder:@"Password"];
    [[self view]addSubview:self.passwordField];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginBtn setTitle:@"login" forState:UIControlStateNormal];
    [self.loginBtn sizeToFit];
    [self.view addSubview:self.loginBtn];
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).with.mas_offset(20);
        make.leading.equalTo(self.view.mas_leading).with.mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.mas_offset(-20);
    }];
}

- (void)setUpUISignal{
    
    RACChannelTo(self.usernameField,text) = RACChannelTo(self,self.loginViewModel.userName);
    [self.usernameField.rac_newTextChannel subscribe:RACChannelTo(self,self.loginViewModel.userName)];
    RACChannelTo(self.passwordField,text) = RACChannelTo(self,self.loginViewModel.passWord);
    [self.passwordField.rac_newTextChannel subscribe:RACChannelTo(self,self.loginViewModel.passWord)];
    
     __weak typeof(self) weakSelf = self;
    [[self.passwordField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
       __strong typeof(weakSelf) self = weakSelf;
      [[self loginViewModel] login];
    }];
    
    //当两个文本输入框都有值的时候,按钮才可点击
    RAC(self.loginBtn, enabled) = [RACSignal combineLatest:@[self.usernameField.rac_textSignal, self.passwordField.rac_textSignal]
                                                        reduce:^id _Nullable(NSString * username, NSString * password){
                                                            return @(username.length && password.length);
                                                        }];

    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong typeof(weakSelf) self = weakSelf;
        [[self loginViewModel] login];
    }];
    
    [RACObserve(self.loginViewModel,token) subscribeNext:^(NSString *x) {
        if (x && [x length] > 0) {
            [self showToast:@"登录成功"];
        }
    }];
    
    
    [RACObserve(self.loginViewModel,errorMsg) subscribeNext:^(NSString *x) {
        if (x && [x length] > 0) {
            [self showToast:[NSString stringWithFormat:@"登录失败%@",x]];
        }
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
@end
