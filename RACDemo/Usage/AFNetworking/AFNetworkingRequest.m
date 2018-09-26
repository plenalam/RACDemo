////AFNetworkingRequest.m 
// RACDemo 
// 
// Created by Plena on 2018/9/25. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import "AFNetworkingRequest.h"
#import <AFNetworking/AFNetworking.h>

static AFNetworkingRequest * _instance = nil;
static AFHTTPSessionManager* _sessionManager = nil;
@implementation AFNetworkingRequest

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

-(RACSignal*)rac_GetWithUrl:(NSString *)url params:(NSDictionary *)params{
//    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        return [self NetWorkFailSignal];
//    }
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [_sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
            NSLog(@"success--%@--%@",[responseObject class],responseObject);
            [subscriber sendNext:[responseObject objectForKey:@"message"]];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(RACSignal*)rac_PostWithUrl:(NSString *)url params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [_sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success--%@--%@",[responseObject class],responseObject);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(RACSignal*)NetWorkFailSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendError:[[NSError alloc] initWithDomain:@"" code:1 userInfo:@{}]];
        return [RACDisposable disposableWithBlock:^{
           
        }];
    }];
}

@end
