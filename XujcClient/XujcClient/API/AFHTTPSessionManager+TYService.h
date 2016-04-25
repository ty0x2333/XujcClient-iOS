//
//  AFHTTPSessionManager+TYService.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, VerificationCodeType) {
    VerificationCodeTypeSignUp,
    VerificationCodeTypeChangePasswordUp,
};

@interface AFHTTPSessionManager (TYService)

+ (instancetype)ty_manager;

+ (NSString *)ty_serviceBaseURL;

+ (NSString *)ty_shareURL;

- (RACSignal *)requestBindingXujcAccountSignalWithXujcKey:(NSString *)xujcKey;

- (RACSignal *)requestLoginSignalWithPhone:(NSString *)phone andPassword:(NSString *)password;

- (RACSignal *)requestProfileSignal;

- (RACSignal *)requestSignupSignalWithPhone:(NSString *)phone andPassword:(NSString *)password andName:(NSString *)name andVertificationCode:(NSString *)code;

- (RACSignal *)requestChangePasswordSignalWithPhone:(NSString *)phone andPassword:(NSString *)password andVertificationCode:(NSString *)code;

- (RACSignal *)requestGetVerificationCodeSignalWithPhone:(NSString *)phone withType:(VerificationCodeType)codeType;

@end
