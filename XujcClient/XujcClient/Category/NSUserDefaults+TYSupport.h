//
//  NSUserDefaults+TYSupport.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (TYSupport)

- (RACChannelTerminal *)ty_channelTerminalForApiKey;

- (RACChannelTerminal *)ty_channelTerminalForXujcKey;

- (RACChannelTerminal *)ty_channelTerminalForShakingReportStatus;

- (RACChannelTerminal *)ty_channelTerminalForUser;

@end
