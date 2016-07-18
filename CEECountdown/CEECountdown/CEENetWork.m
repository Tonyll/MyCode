//
//  CEENetWork.m
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CEENetWork.h"
#import <OpenUDID.h>

@implementation CEENetWork

+ (instancetype)sharedManager {
    static CEENetWork *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}
    
- (void)requestWithMethod:(HTTPMethodType)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure
{
    switch (method) {
        case GET:{
            [self GET:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                failure(error);
            }];
            break;
        }
        case POST:{
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            [dic setValue:[self getGParam] forKey:@"G"];
            [dic setValue:[self getOpenUDID] forKey:@"deviceId"];
            NSLog(@"请求参数: %@",dic);
            [self POST:path parameters:@{@"jsonParams":[dic JSONString]} progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                failure(error);
            }];
            break;
        }
        default:
            break;
    }    
}

-(NSDictionary*)getGParam
{
    
    NSString *strBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray *versions = [strBuild componentsSeparatedByString:@"."];
    __block NSInteger versionInt = 0;
    [versions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger n1 = [obj integerValue];
        NSInteger k = 0;
        
        switch (idx) {
            case 0:
                k = 100;
                break;
            case 1:
                k = 10;
                break;
            case 2:
                k = 1;
                break;
            default:
                break;
        }
        versionInt += n1 * k;
    }];
    
    NSDictionary *dic =
    @{
      @"dt":@"2",
      @"deviceId":[self getOpenUDID],
      @"at":@"3",
      @"av":@(versionInt),
      @"sv":@"103",
      };
    
    
    return dic;
}

- (NSString *)getOpenUDID{
    NSString *openUDID = [OpenUDID value];
    return openUDID;
}

@end
