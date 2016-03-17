//
//  UIImage+Coding.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UIImage+Coding.h"
#import "NSData+Coding.h"

@implementation UIImage (Coding)

- (NSString *)base64String
{
    return [[self imageData] base64EncodedStringWithOptions:0];
}

- (NSString *)MD5
{
    return [[self imageData] MD5];
}

- (NSData *)imageData
{
    return [self hasAlpha] ? UIImagePNGRepresentation(self) : UIImageJPEGRepresentation(self, 1.0f);
}

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

@end
