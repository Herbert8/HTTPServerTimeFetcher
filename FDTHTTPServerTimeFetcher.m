//
//  FDTHTTPServerTimeFetcher.m
//  TestGetServerTime
//
//  Created by 巴宏斌 on 2018/4/1.
//  Copyright © 2018年 巴宏斌. All rights reserved.
//

#import "FDTHTTPServerTimeFetcher.h"

@implementation FDTHTTPServerTimeFetcher


- (void)fetchTimeFromHTTPServer:(NSURL *)url callback:(void(^)(NSDate *))callbackBlock {

    NSDictionary *headers = @{ @"Cache-Control": @"no-cache" };

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"HEAD"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        callbackBlock(nil);
                                                        NSLog(@"Exec HTTP HEAD error = %@", error);
                                                    } else {
                                                        NSDate *date = [self extractTimeFromResponse:response];
                                                        callbackBlock(date);
                                                    }
                                                }];
    [dataTask resume];
}

- (NSDate *)extractTimeFromResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *allResHeader = httpResponse.allHeaderFields;
    NSString *dateStr = allResHeader[@"Date"];
    return [self dateFromString:dateStr];
}

- (NSDate *)dateFromString:(NSString *)dateStr {
    // 创建日期格式化工具
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    // 指定日期格式，如上所示：Sun, 01 Apr 2018 01:18:07 GMT
    dateFormatter.dateFormat = @"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss 'GMT'";
    // 指定区域，这个很重要！EEE、MMM 会根据区域设置进行处理。如果这里设置为中文，则只能处理 “四月”、“周日”，而不能处理 “Apr”、“Sun”
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    // 指定所使用的是 UTC 时间
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

    return [dateFormatter dateFromString:dateStr];
}

@end
