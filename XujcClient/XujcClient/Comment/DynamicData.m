/**
 * @file DynamicData.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "DynamicData.h"
#import "XujcTerm.h"
static NSString* const kDataXujcUser = @"User";
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
    NSArray *termDataArray = [userDefaults objectForKey:kDataXujcTerms];
    NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:termDataArray.count];
    for (NSData *data in termDataArray) {
        XujcTerm *term = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [termArray addObject:term];
    }
    // 使用 setTerm 使其排序, 勿用 _term
    [self setTerms:termArray];
    TyLogDebug(@"DynamicData Loaded:%@", [self description]);
}

- (void)flush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_user data] forKey:kDataXujcUser];
    
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
    UserModel *user = [[UserModel alloc] init];
    _user = user;
    [self flush];
}

#pragma mark - Setter

- (void)setTerms:(NSArray *)terms
{
    // 使用 termId 升序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"termId" ascending:YES];
    _terms = [terms sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
}

#pragma mark - Getter

- (NSString *)apiKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyApiKey];
}

- (NSString *)xujcKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyXujcKey];
}

#pragma mark - Other

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\tAPIKey: %@\n\tUser: %@\n}", self.apiKey, [_user description]];
}

@end
