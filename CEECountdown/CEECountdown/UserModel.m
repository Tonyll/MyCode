//
//  UserModel.m
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
//             @"userName"    :     @"userName",
//             @"password"    :     @"password",
             @"birthday"    :     @"birthday",
             @"imageUrl"    :     @"imageUrl",
             @"nickName"    :     @"nickName",
             @"sex"         :     @"sex",
             @"hometown"    :     @"hometown",
             @"favorite"    :     @"favorite",
             @"qq"          :     @"qq"
             };
}

@end
