//
//  HTTPMethod.h
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#ifndef HTTPMethod_h
#define HTTPMethod_h

typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethodType;

#ifdef DEBUG
#define BASE_URL @"innerapi1.jiemodou.net"
#else
#define BASE_URL @"innerapi.jiemo.net"
#endif

#define URL_USER                        @"http://"BASE_URL@"/User"
#define URL_UPLOAD                      @"http://"BASE_URL@"/Upload"

#define URL_UTILS_UPLOADIMAGE           URL_UPLOAD@"/uploadHeader"              // 更新头像 type:1 更新头像， type：2 上传帖子图片
#define URL_USER_LOGIN                   URL_USER@"/login"                    // 登陆
#define URL_USER_REGISTER                URL_USER@"/register"                 // 注册
#define URL_USER_FINDPASS                URL_USER@"/findPass"                 // 找回密码
#define URL_UTILS_CAPCHA                 URL_USER@"/getCaptcha"               // 获取验证码

#endif /* HTTPMethod_h */
