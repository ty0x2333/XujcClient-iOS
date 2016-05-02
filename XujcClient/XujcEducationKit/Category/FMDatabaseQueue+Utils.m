//
//  FMDatabaseQueue+Utils.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "FMDatabaseQueue+Utils.h"

#define DOCUMENT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static NSString * const kDBName = @"DataCache";

@implementation FMDatabaseQueue (Utils)

+ (instancetype)instance
{
    static FMDatabaseQueue *databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[NSString stringWithFormat:@"%@/%@.db", DOCUMENT_DIRECTORY, kDBName]];
    });
    return databaseQueue;
}

@end
