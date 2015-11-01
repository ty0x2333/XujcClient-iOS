/**
 * @file DynamicData.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "DynamicData.h"
#import "XujcTerm.h"
static NSString* const kDataXujcUser = @"XujcUser";
static NSString* const kDataXujcAPIKey = @"APIKey";
static NSString* const kDataXujcTerms = @"XujcTerms";


@implementation DynamicData

+ (instancetype)instance
{
    static DynamicData *shareDynamicDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareDynamicDataInstance = [[self alloc] init];
    });
    return shareDynamicDataInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        [self loadingSettings];
    }
    return self;
}

#pragma mark - Load And Flush

- (void)loadingSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _user = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kDataXujcUser]];
    _APIKey = [userDefaults stringForKey:kDataXujcAPIKey];
    NSArray *termDataArray = [userDefaults objectForKey:kDataXujcTerms];
    NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:termDataArray.count];
    for (NSData *data in termDataArray) {
        XujcTerm *term = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [termArray addObject:term];
    }
    _terms = termArray;
    TyLogDebug(@"DynamicData Loaded:%@", [self description]);
}

- (void)flush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_user data] forKey:kDataXujcUser];
    
    [userDefaults setObject:_APIKey forKey:kDataXujcAPIKey];
    
    NSMutableArray *termDataArray = [NSMutableArray arrayWithCapacity:_terms.count];
    for (XujcTerm *term in _terms) {
        [termDataArray addObject:[term data]];
    }
    [userDefaults setObject:termDataArray forKey:kDataXujcTerms];
    TyLogDebug(@"DynamicData Flush:%@", [self description]);
    
    [userDefaults synchronize];
}

- (void)clear
{
    XujcUser *user = [[XujcUser alloc] init];
    _user = user;
    [self flush];
}

#pragma mark - Other

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\tAPIKey: %@\n\tUser: %@\n}", _APIKey, [_user description]];
}

@end
