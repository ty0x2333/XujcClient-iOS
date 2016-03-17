//
//  NSData+Coding.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSData+Coding.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Coding)

- (NSString *)MD5
{
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5([self bytes], (CC_LONG)[self length], digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int  i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
        [outPutStr appendFormat:@"%02x",digist[i]];
    }
    
    return [outPutStr lowercaseString];
}

@end