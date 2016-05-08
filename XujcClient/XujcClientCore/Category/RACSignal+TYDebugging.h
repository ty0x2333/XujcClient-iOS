//
//  RACSignal+TYDebugging.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/23.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

/// Additional methods to assist with debugging.
@interface RACSignal (TYDebugging)

/// Logs all events that the receiver sends by color.
- (RACSignal *)ty_logAll;

/// Logs each `next` that the receiver sends by color.
- (RACSignal *)ty_logNext;

/// Logs any error that the receiver sends by color.
- (RACSignal *)ty_logError;

/// Logs any `completed` event that the receiver sends by color.
- (RACSignal *)ty_logCompleted;

@end
