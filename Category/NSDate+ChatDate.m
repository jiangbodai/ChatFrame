//
//  NSDate+ChatDate.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/21.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "NSDate+ChatDate.h"

@implementation NSDate (ChatDate)

+ (NSString *)currentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

@end
