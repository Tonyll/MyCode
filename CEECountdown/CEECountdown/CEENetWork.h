//
//  CEENetWork.h
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "HTTPConfig.h"

@interface CEENetWork : AFHTTPSessionManager

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

typedef void (^responseHandler)(id responseObject, NSError *error);

+ (instancetype)sharedManager;

- (void)requestWithMethod:(HTTPMethodType)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;

@end
