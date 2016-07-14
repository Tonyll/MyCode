//
//  UserViewModel.m
//  CEECountdown
//
//  Created by Tony L on 7/13/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserViewModel.h"

@implementation UserViewModel

- (instancetype)initWithUser:(UserModel *)user {
    self = [super init];
    if (self) {
        self.userName = user.userName;
        self.password = user.password;
    }
    
    return self;
}

//判断用户名、密码是否有效

- (BOOL)isUserNameValid {
    return [self.userName containsString:@"boo"];
}

- (BOOL)isPasswordValid {
    return [self.password containsString:@"666"];
}

- (BOOL)isCanLogin {
    return self.isUserNameValid && self.isPasswordValid;
}

- (RACSignal *)isCanLoginSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (self.isUserNameValid && self.isPasswordValid) {
            [subscriber sendNext:@(true)];
        }
        [subscriber sendNext:@(false)];
        return nil;
    }];
    
    return signal;
}

@end
