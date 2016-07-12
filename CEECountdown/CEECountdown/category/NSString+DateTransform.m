//
//  NSString+DateTransform.m
//  UI14-QQ
//
//  Created by neuedu on 15/8/27.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NSString+DateTransform.h"

@implementation NSString (DateTransform)
+(instancetype)HMSWithDate:(NSDate *)date{
    if(date == nil){
        date = [NSDate date];
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [formater stringFromDate:date];
    return dateString;
}
+(instancetype)YMDWithDate:(NSDate *)date{
    if(date == nil){
        date = [NSDate date];
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formater stringFromDate:date];
    return dateString;
}
+(instancetype)HMWithDate:(NSDate *)date{
    if(date == nil){
        date = [NSDate date];
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"HH:mm"];
    NSString *dateString = [formater stringFromDate:date];
    return dateString;
}

//如果传入的时间是同一天，显示今天 如果早一天 昨天 显示到前天
+(instancetype)YMDHMWithDate:(NSDate *)date{
    if(date == nil){
        date = [NSDate date];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *datet = [format stringFromDate:date];
    
    NSDate* today = [format dateFromString:datet];

    
    NSString *dateString = nil;
    //把传入的date和当前时间比较
    NSTimeInterval timeRange  = [today timeIntervalSinceNow];
    timeRange = ABS(timeRange);
    int day =(int)timeRange/(24*60*60);
    
    
    
    
    switch (day) {
        case 0:
            dateString = [NSString stringWithFormat:@"今天 %@",[NSString HMWithDate:date]];
            break;
        case 1:
            dateString = [NSString stringWithFormat:@"昨天 %@",[NSString HMWithDate:date]];
            break;
        case 2:
            dateString = [NSString stringWithFormat:@"前天 %@",[NSString HMWithDate:date]];
            break;
            
        default:
        {
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateString = [formater stringFromDate:date];
        }
            break;
    }
    
    
    
    
    return dateString;
}
@end
