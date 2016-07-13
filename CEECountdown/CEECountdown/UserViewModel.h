//
//  UserViewModel.h
//  CEECountdown
//
//  Created by Tony L on 7/13/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserViewModel : NSObject

- (instancetype)initWithUser:(User *)user;

@property (strong, nonatomic, readwrite) NSString *userName;
@property (assign, nonatomic, readonly, getter=isUserNameValid) BOOL userNameValid;

@property (strong, nonatomic, readwrite) NSString *password;
@property (assign, nonatomic, readonly, getter=isPasswordValid) BOOL passwordVaild;

- (BOOL)isCanLogin;

- (RACSignal *)isCanLoginSignal;

@end
