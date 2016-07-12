//
//  NSString+MoreExtentions.m
//  UI2-微博
//
//  Created by hegf on 15/8/24.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NSString+MoreExtentions.h"

@implementation NSString (MoreExtentions)


-(BOOL)validatePhoneNumber{
    NSString * number = @"^1[0,3,4,5,7,8][0-9]{9}$";
    NSPredicate * numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}

@end
