//
//  RACSignal+TYDebugging.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/23.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RACSignal+TYDebugging.h"

@implementation RACSignal (TYDebugging)

- (RACSignal *)ty_logAll {
    return [[[self ty_logNext] ty_logError] ty_logCompleted];
}

- (RACSignal *)ty_logNext {
    return [[self doNext:^(id x) {
        TyLogDebug(@"%@ next: %@", self, x);
    }] setNameWithFormat:@"%@", self.name];
}

- (RACSignal *)ty_logError {
    return [[self doError:^(NSError *error) {
        TyLogFatal(@"%@ error: %@", self, error);
    }] setNameWithFormat:@"%@", self.name];
}

- (RACSignal *)ty_logCompleted {
    return [[self doCompleted:^{
        TyLogDebug(@"%@ completed", self);
    }] setNameWithFormat:@"%@", self.name];
}

@end
