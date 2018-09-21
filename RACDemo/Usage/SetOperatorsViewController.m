////SetOperatorsViewController.m 
// RACDemo 
// 
// Created by Plena on 2018/9/20. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "SetOperatorsViewController.h"

@interface SetOperatorsViewController ()
@property (nonatomic,strong) UIButton * arrayBtn;
@property (nonatomic,strong) UIButton * arrayMapBtn;
@property (nonatomic,strong) UIButton * dictionaryBtn;
@end

@implementation SetOperatorsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions/Event Response

- (void)earchArray{
    NSArray* array = @[@"A",@"B",@"C",@"D"];
    [[[array.rac_sequence.signal filter:^BOOL(NSString *value) {
        return ![value isEqualToString:@"B"];
    }] subscribeOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         NSLog(@"subscribeNext:%@",x);
     } completed:^{
         NSLog(@"completed");
     }];
    
}

- (void) arrayMap{
    NSArray* array = @[@"A",@"B",@"C",@"D"];
   RACSequence *sequence = [array.rac_sequence map:^id(id value) {
        return [NSString stringWithFormat:@"map%@",value];
    }] ;
    [sequence.signal subscribeNext:^(id x) {
        NSLog(@"after map:%@",x);
    }];

}

- (void)earchDic{
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    [[dictionary.rac_sequence.signal filter:^BOOL(id value) {
        RACTupleUnpack(NSString *tkey, NSString *tvalue) = value;
        return ![tkey containsString:@"2"];
    }] subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"[rac_sequence] key: %@ value: %@", key, value);
    } completed:^{
         NSLog(@"completed");
    }];
    
    [[dictionary.rac_keySequence.signal deliverOn:[RACScheduler scheduler]]subscribeNext:^(id x) {
        NSLog(@"[rac_keySequence] thread:%@ key:%@",[NSThread currentThread],x);
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
    self.arrayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.arrayBtn setTitle:@"each array" forState:UIControlStateNormal];
    [[self view]addSubview:   self.arrayBtn];
    [self.arrayBtn sizeToFit];
    [self.arrayBtn addTarget:self action:@selector(earchArray) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.arrayMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.arrayMapBtn setTitle:@"map array" forState:UIControlStateNormal];
    [[self view]addSubview:     self.arrayMapBtn];
    [self.arrayMapBtn sizeToFit];
    [self.arrayMapBtn addTarget:self action:@selector(arrayMap) forControlEvents:UIControlEventTouchUpInside];
    
    self.dictionaryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dictionaryBtn setTitle:@"each dictionary" forState:UIControlStateNormal];
    [[self view]addSubview:     self.dictionaryBtn];
    [self.dictionaryBtn sizeToFit];
    [self.dictionaryBtn addTarget:self action:@selector(earchDic) forControlEvents:UIControlEventTouchUpInside];
}
# pragma mark layoutPageSubviews
-(void)layoutPageSubviews{
    [self.arrayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.arrayMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrayBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.dictionaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrayMapBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
