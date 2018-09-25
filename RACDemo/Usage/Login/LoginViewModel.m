////LoginViewModel.m 
// RACDemo 
// 
// Created by Plena on 2018/9/21. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "LoginViewModel.h"
#import "UserInfo.h"
@interface LoginViewModel()

@end
@implementation LoginViewModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _userName = @"admin";
        _passWord = @"123456";
    }
    return self;
}

- (void)login{
       __weak typeof(self) weakSelf = self;
    RACSignal* loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"token111122222"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposable");
        }];
    }];
    [[[loginSignal subscribeOn:[RACScheduler scheduler]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         __strong typeof(weakSelf) self = weakSelf;
         [self setToken:x];
     }error:^(NSError *error) {
        __strong typeof(weakSelf) self = weakSelf;
         [self setErrorMsg:[error localizedDescription]];
     } completed:^{
         
     }];
}


@end
