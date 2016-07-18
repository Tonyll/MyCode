//
//  Macro.h
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#ifndef CEEMacro_h
#define CEEMacro_h

typedef enum{
    CEEErrorMobileForm       = 9000,           /*! 手机号格式错误 */
    CEEErrorMobileAlreadyRegist,               /*! 手机号已注册 */
    CEEErrorMsgSendFail,                       /*!验证码发送失败*/
    CEEErrorPasswordForm,                      /*!密码格式错误*/
    CEEErrorVerificationCode = 9005,           /*!验证码错误*/
    CEEErrorMobileIsNull = 9007,               /*!手机号为空*/
    CEEErrorPwdOrMobile      = 9008,           /*!密码错误或手机号错误*/
    CEEErrorMobileNotExit,                     /*!手机号不存在*/
}CEEErrorCode;

#define KNOTIFICATION_USERINFO_CHANGE @"kNotification_userInfo_change"

#endif /* CEEMacro_h */
