//
//  UIImage+Coding.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Coding)

- (NSString *)base64String;

- (NSString *)MD5;

- (NSData *)imageData;

@end
