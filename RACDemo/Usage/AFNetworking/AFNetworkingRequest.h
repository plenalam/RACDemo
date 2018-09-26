////AFNetworkingRequest.h 
// RACDemo 
// 
// Created by Plena on 2018/9/25. 
// Copyright © 2018年 Plena. All rights reserved. 
// 

#import <Foundation/Foundation.h>

@interface AFNetworkingRequest : NSObject
+(instancetype) sharedInstance;
-(RACSignal*)rac_GetWithUrl:(NSString *)url params:(NSDictionary *)params;

-(RACSignal*)rac_PostWithUrl:(NSString *)url params:(NSDictionary *)params;
@end
