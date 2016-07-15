//
//  CEEUtils.h
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface CEEUtils : NSObject

+ (NSString *)errorCodeHandle:(NSInteger)errorCode;

+ (BOOL)NoNetFunc;

+ (void)saveUserInfoToLocal:(NSString *)jsonStr;

+ (UserModel *)getUserInfoFromLocal;

@end
