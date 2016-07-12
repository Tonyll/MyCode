//
//  NSString+DateTransform.h
//  UI14-QQ聊天界面
//
//  Created by hegf on 15/8/27.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 [NSString HMWithDate:now];
 [NSString HMSWithDate:now];
 [NSString YMDWithDate:now];
 */
@interface NSString (DateTransform)

//如果你传入的date 是 nil 返回的是当前的时间字符串
//取得小时：分 比如11:23
+(instancetype)HMWithDate:(NSDate*)date;
//取得小时：分 秒 比如11:23:42
+(instancetype)HMSWithDate:(NSDate*)date;
//取得年月日 比如2015-08-27
+(instancetype)YMDWithDate:(NSDate*)date;

@end
