//
//  CBJsonModel.m
//  CBJsonModel
//
//  Created by 0xcb on 2017/5/8.
//  Copyright © 2017年 changbiao. All rights reserved.
//

#import "CBJsonModel.h"



@implementation CBJsonModel
+ (instancetype)modelFromJson:(NSString *)jsonString
{
    NSError *error = nil;
    CBJsonModel *mod = [[[self class] alloc] initWithString:jsonString usingEncoding:NSUTF8StringEncoding error:&error];
    if (error) {
        AFLog(@"#注意! json对象转换错误 %@", error);
    }
    return mod;
}

+ (instancetype)modelFromDict:(NSDictionary *)jsonDict
{
    NSError *error = nil;
    CBJsonModel *mod = [[[self class] alloc] initWithDictionary:jsonDict error:&error];
    if (error) {
        AFLog(@"#注意! json对象转换错误 %@", error);
    }
    return mod;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    AFLog(@"注意设置未定义的kv =====  {%@:%@}", key, value);
}

@end



@implementation NSString (__0xcb__)
- (NSURL *)cbURL
{
    NSString *trimStr = self.cbTrim;
    if ([trimStr hasPrefix:@"http"]) {
        return [NSURL URLWithString:trimStr];
    }else if ([trimStr hasPrefix:@"/"] && trimStr.length){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AFCBImageCDN, trimStr]];
    }else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", AFCBImageCDN, trimStr]];
    }
}

- (NSNumber *)cbIntNumber
{
    return [NSNumber numberWithInteger:[self integerValue]];
}

- (NSString *)cbAppend:(NSString *)aString
{
    return [self stringByAppendingString:aString];
}

- (NSString *)cbReplace:(NSString *)aString with:(NSString *)repString
{
    repString = repString ?: @"";
    return [self stringByReplacingOccurrencesOfString:aString withString:repString];
}

+ (NSString *)cbFormatSize:(NSUInteger)size
{
    CGFloat M = 1024 * 1024;
    NSString *str = @"0MB";
    if (size > M) {
        CGFloat sizef = size / M;
        str = [NSString stringWithFormat:@"%.1fMB", sizef];
    }else if (size > 1024) {
        CGFloat sizef = size / 1024.0f;
        str = [NSString stringWithFormat:@"%.1fKB", sizef];
    }else if (size > 0) {
        str = [NSString stringWithFormat:@"%ldB", size];
    }
    return [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
}

- (NSString *)cbTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)cbIsEmpty:(NSString *)str
{
    return !(str && [str isKindOfClass:[NSString class]] && str.length);
}

- (BOOL)cbRegex:(NSString *)regex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)cbIsEmail
{
    return [self cbRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)cbIsMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //return [self cbRegex:@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"];
    return [self cbRegex:@"^1(3|4|5|7|8)\\d{9}$"];
}

//车牌号验证
- (BOOL)cbIsCarNo
{
    return [self cbRegex:@"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"];
}

//车型
- (BOOL)cbIsCarType
{
    return [self cbRegex:@"^[\u4E00-\u9FFF]+$"];
}

//用户名
- (BOOL)cbIsUserName
{
    return [self cbRegex:@"^[A-Za-z0-9]{6,20}+$"];
}

//密码
- (BOOL)cbIsPassword
{
    return [self cbRegex:@"^[a-zA-Z0-9]{6,20}+$"];
}

//昵称
- (BOOL)cbIsNickname
{
    return [self cbRegex:@"^[\u4e00-\u9fa5]{4,8}$"];
}

//身份证号
- (BOOL)cbIsIdentityCard
{
    return [self cbRegex:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

@end


@implementation NSNumber (__0xcb__)

- (BOOL)cbBool
{
    return [self boolValue];
}

- (int)cbInt
{
    return [self intValue];
}

- (long)cbLong
{
    return [self longValue];
}

- (float)cbFloat
{
    return [self floatValue];
}

- (double)cbDouble
{
    return [self doubleValue];
}

- (NSTimeInterval)cb_timestamp
{
    NSTimeInterval time = self.cbDouble;
    //1491545845483
    //1491545845
    if (time > 9999999999) {
        //from java
        time = time / 1000.0f;
    }
    return time;
}

- (NSDate *)cbDate
{
    NSTimeInterval time = [self cb_timestamp];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSString *)cbTimestamp
{
    NSTimeInterval time = self.cbDouble;
    //1491545845483
    //1491545845
    if (time < 9999999999) {
        //from oc
        time = time * 1000.0f;
    }
    return [NSString stringWithFormat:@"%.0f", time];
}

- (NSString *)cbPriceString
{
    return [NSString stringWithFormat:@"¥%.2f", [self floatValue]];
}

- (NSString *)cbString
{
    return [NSString stringWithFormat:@"%@", self];
}

- (NSString *)cbDateStringWithFmt:(NSString *)fmtStr
{
    //hh与HH的区别:分别表示12小时制,24小时制
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = fmtStr;
    NSString* dateString = [fmt stringFromDate:self.cbDate];
    return dateString;
}

- (NSString *)cbDateYYYY_MM_DD
{
    return [self cbDateStringWithFmt:@"yyyy-MM-dd"];
}
- (NSString *)cbDateYYYY_MM_DD_HH_mm
{
    return [self cbDateStringWithFmt:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)cbDateMM_DD_HH_mm
{
    return [self cbDateStringWithFmt:@"MM-dd HH:mm"];
}

@end
