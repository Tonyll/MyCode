//
//  CEEUtils.m
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CEEUtils.h"

@implementation CEEUtils

+ (NSString *)errorCodeHandle:(NSInteger)errorCode{
    NSString *returnStr = @"登录失败";
    switch (errorCode) {
        case CEEErrorMobileForm:
            returnStr = @"手机号格式错误";
            break;
        case CEEErrorMobileAlreadyRegist:
            returnStr = @"手机号已注册";
            break;
        case CEEErrorMsgSendFail:
            returnStr = @"验证码发送失败";
            break;
        case CEEErrorPasswordForm:
            returnStr = @"密码格式错误";
            break;
        case CEEErrorVerificationCode:
            returnStr = @"验证码错误";
            break;
        case CEEErrorMobileIsNull:
            returnStr = @"手机号为空";
            break;
        case CEEErrorPwdOrMobile:
            returnStr = @"手机号或密码错误";
            break;
        case CEEErrorMobileNotExit:
            returnStr = @"手机号不存在";
            break;
            
        default:
            break;
    }
    
    return returnStr;
}

+ (BOOL)NoNetFunc
{
    if([[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus] == NotReachable)
    {
        return YES;
    }
    else return NO ;
}

+ (void)saveUserInfoToLocal:(NSString *)jsonStr{
    LOCAL_SET_USERINFO(jsonStr);
    LOCAL_SYNCHRONIZE;
}

+ (UserModel *)getUserInfoFromLocal{
    NSString *userInfoStr = LOCAL_GET_USERINFO;
    UserModel *userModel = [UserModel yy_modelWithJSON:userInfoStr];
    return userModel;
}

@end
