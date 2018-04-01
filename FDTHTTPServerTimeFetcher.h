//
//  FDTHTTPServerTimeFetcher.h
//  TestGetServerTime
//
//  Created by 巴宏斌 on 2018/4/1.
//  Copyright © 2018年 巴宏斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDTHTTPServerTimeFetcher : NSObject

- (void)fetchTimeFromHTTPServer:(NSURL *)url
                     callback:(void(^)(NSDate *))callbackBlock;

@end
