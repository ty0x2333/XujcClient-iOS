//
//  UserModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/6.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UserModel.h"
#import "TYService.h"

@implementation UserModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _nikename = [self checkForNull:json[TYServiceKeyNickname]];
        _phone = [self checkForNull:json[TYServiceKeyPhone]];
        _email = [self checkForNull:json[TYServiceKeyEmail]];
        _createdTime = [self checkForNull:json[TYServiceKeyCreatedTime]];
        _avatar = [self checkForNull:json[TYServiceKeyAvatar]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _nikename = [decoder decodeObjectForKey:TYServiceKeyNickname];
        _phone = [decoder decodeObjectForKey:TYServiceKeyPhone];
        _email = [decoder decodeObjectForKey:TYServiceKeyEmail];
        _avatar = [decoder decodeObjectForKey:TYServiceKeyAvatar];
        _createdTime = [decoder decodeObjectForKey:TYServiceKeyCreatedTime];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_nikename forKey:TYServiceKeyNickname];
    [encoder encodeObject:_phone forKey:TYServiceKeyPhone];
    [encoder encodeObject:_email forKey:TYServiceKeyEmail];
    [encoder encodeObject:_createdTime forKey:TYServiceKeyCreatedTime];
    [encoder encodeObject:_avatar forKey:TYServiceKeyAvatar];
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
             TYServiceKeyNickname: _nikename ?: null,
             TYServiceKeyPhone: _phone ?: null,
             TYServiceKeyEmail: _email ?: null,
             TYServiceKeyCreatedTime: _createdTime ?: null,
             TYServiceKeyAvatar: _avatar ?: null
             };
}

@end
