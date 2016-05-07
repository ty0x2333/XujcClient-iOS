//
//  FMDatabaseQueue+Utils.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "FMDatabaseQueue+Utils.h"

#define DOCUMENT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static NSString * const kAppGroupName = @"group.com.tianyiyan.xujcclient";

static NSString * const kDBName = @"DataCache";

@implementation FMDatabaseQueue (Utils)

+ (instancetype)instance
{
    static FMDatabaseQueue *databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.tianyiyan.xujcclient"];
        NSURL *path = [groupURL URLByAppendingPathComponent:kDBName];
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[path absoluteString]];
    });
    return databaseQueue;
}

@end
