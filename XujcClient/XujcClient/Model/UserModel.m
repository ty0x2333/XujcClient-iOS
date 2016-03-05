//
//  UserModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/6.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UserModel.h"
#import "TYServer.h"

@implementation UserModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _nikename = [self checkForNull:json[TYServerKeyNickname]];
        _email = [self checkForNull:json[TYServerKeyEmail]];
        _apiKey = [self checkForNull:json[TYServerKeyAPIKey]];
        _xujcKey = [self checkForNull:json[TYServerKeyXujcKey]];
        _createdTime = [self checkForNull:json[TYServerKeyCreatedTime]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _nikename = [decoder decodeObjectForKey:TYServerKeyNickname];
        _email = [decoder decodeObjectForKey:TYServerKeyEmail];
        _apiKey = [decoder decodeObjectForKey:TYServerKeyAPIKey];
        _xujcKey = [decoder decodeObjectForKey:TYServerKeyXujcKey];
        _createdTime = [decoder decodeObjectForKey:TYServerKeyCreatedTime];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_nikename forKey:TYServerKeyNickname];
    [encoder encodeObject:_email forKey:TYServerKeyEmail];
    [encoder encodeObject:_apiKey forKey:TYServerKeyAPIKey];
    [encoder encodeObject:_xujcKey forKey:TYServerKeyXujcKey];
    [encoder encodeObject:_createdTime forKey:TYServerKeyCreatedTime];
}

- (NSString *)description
{
    return [[self p_dictionaryRepresentation] description];
}

#pragma mark - Helper

- (NSDictionary *)p_dictionaryRepresentation
{
    NSString *null = @"";
    return @{
             TYServerKeyNickname: _nikename ?: null,
             TYServerKeyEmail: _email ?: null,
             TYServerKeyAPIKey: _apiKey ?: null,
             TYServerKeyXujcKey: _xujcKey ?: null,
             TYServerKeyCreatedTime: _createdTime ?: null,
             };
}

@end
