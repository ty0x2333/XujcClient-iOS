//
//  NSUserDefaults+TYSupport.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSUserDefaults+TYSupport.h"

@implementation NSUserDefaults (TYSupport)

- (RACChannelTerminal *)ty_channelTerminalForApiKey
{
    return [self rac_channelTerminalForKey:kUserDefaultsKeyApiKey];
}

- (RACChannelTerminal *)ty_channelTerminalForXujcKey
{
    return [self rac_channelTerminalForKey:kUserDefaultsKeyXujcKey];
}

- (RACChannelTerminal *)ty_channelTerminalForShakingReportStatus
{
    return [self rac_channelTerminalForKey:kUserDefaultsKeyShakingReportStatus];
}

- (RACChannelTerminal *)ty_channelTerminalForUser
{
    return [self rac_channelTerminalForKey:kUserDefaultsKeyUser];
}

@end
