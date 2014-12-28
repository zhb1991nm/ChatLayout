//
//  NSString+URL.m
//  BrokerMarkerIOS
//
//  Created by icode on 14-5-21.
//  Copyright (c) 2014年 sinitek. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString{
    NSString *encodeString =  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    //NSLog(@"已加密已编码：%@",encodeString);
    return encodeString;
}

- (NSString *)trimmedString{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" "];
    return [self stringByTrimmingCharactersInSet:set];
}

@end
