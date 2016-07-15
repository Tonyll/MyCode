//
//  UserInfoConfig.h
//  CEECountdown
//
//  Created by Tony L on 7/15/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#ifndef UserInfoConfig_h
#define UserInfoConfig_h

#define LOCAL_SET_USERINFO(x)      [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"CEE_UserInfo"]
#define LOCAL_GET_USERINFO         [[NSUserDefaults standardUserDefaults] objectForKey:@"CEE_UserInfo"]

#define LOCAL_SET_ISLOGIN(x)       [[NSUserDefaults standardUserDefaults] setBool:x forKey:@"CEE_IsLogin"]
#define LOCAL_GET_ISLOGIN          [[NSUserDefaults standardUserDefaults] boolForKey:@"CEE_IsLogin"]

/**
 *  是否弹出时间及身份选择页面
 *
 */
#define LOCAL_SET_ISSHOWTIMEPICKER(x)     [[NSUserDefaults standardUserDefaults] setBool:x forKey:@"CEE_IsShowTimePicker"]
#define LOCAL_GET_ISSHOWTIMEPICKER        [[NSUserDefaults standardUserDefaults] objectForKey:@"CEE_IsShowTimePicker"]

#define LOCAL_SYNCHRONIZE  [[NSUserDefaults standardUserDefaults] synchronize]

#endif /* UserInfoConfig_h */
