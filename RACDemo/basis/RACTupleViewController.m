//
//  RACTupleViewController.m
//  RACDemo
//
//  Created by gxx_mobile on 2018/9/20.
//  Copyright © 2018年 plena. All rights reserved.
//

#import "RACTupleViewController.h"

@interface RACTupleViewController ()
@property (nonatomic,strong) UIButton * sendArrayBtn;
@property (nonatomic,strong) UIButton * sendTupleBtn;
@end

@implementation RACTupleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self layoutViews];
    [self setTitle:@"RACTuple"];
}

- (void)sendArray{
    NSArray * array = @[@1,@2,@3];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"array subscribeNext:%@",x);
    }];
}

- (void)sendTuple{
    // RACTuple *tuple = [RACTuple tupleWithObjects:@1, @2, @3, nil];
    //  RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@1, @2, @3]];
    RACTuple *tuple = RACTuplePack(@1, @2, @3);
    NSLog(@"%@",[tuple objectAtIndex:0]);
    [tuple.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"tuple subscribeNext:%@",x);
    }];
}

-(void)setupViews{
    [[self view]setBackgroundColor:[UIColor whiteColor]];
    self.sendTupleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ self.sendTupleBtn setTitle:@"send Tuple" forState:UIControlStateNormal];
    [[self view]addSubview:  self.sendTupleBtn];
    [ self.sendTupleBtn sizeToFit];
    [ self.sendTupleBtn addTarget:self action:@selector(sendTuple) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendArrayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ self.sendArrayBtn setTitle:@"send Array" forState:UIControlStateNormal];
    [[self view]addSubview:  self.sendArrayBtn];
    [ self.sendArrayBtn sizeToFit];
    [ self.sendArrayBtn addTarget:self action:@selector(sendArray) forControlEvents:UIControlEventTouchUpInside];
}
-(void)layoutViews{
    [self.sendTupleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [ self.sendArrayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendTupleBtn.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}



@end
