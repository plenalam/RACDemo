////LoginViewModel.h 
// RACDemo 
// 
// Created by Plena on 2018/9/21. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *passWord;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *errorMsg;
- (void)login;
@end
