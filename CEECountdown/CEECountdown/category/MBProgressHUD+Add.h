//
//  MBProgressHUD+Add.h
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Add)

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view AfterDelay:(CGFloat)delay;

@end
