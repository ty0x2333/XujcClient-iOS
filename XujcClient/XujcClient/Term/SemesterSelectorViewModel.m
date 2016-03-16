//
//  SemesterSelectorViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterSelectorViewModel.h"
#import "CacheUtils.h"
#import "XujcServer.h"
#import "DynamicData.h"

@interface SemesterSelectorViewModel()

@property (strong, nonatomic) NSArray<XujcSemesterModel *> *semesters;

@end

@implementation SemesterSelectorViewModel

- (instancetype)init
{
    if (self = [super init]) {
        @weakify(self);
        RACSignal *selectedIndexSignal = [RACObserve(self, selectedIndex) filter:^BOOL(NSNumber *value) {
            @strongify(self);
            return [self.semesters objectAtIndex:[value integerValue]];
        }];;
        _selectedSemesterNameSignal = [selectedIndexSignal map:^id(NSNumber *value) {
            @strongify(self);
            return [self selectedSemesterName];
        }];
        
        _selectedSemesterIdSignal = [[selectedIndexSignal map:^id(id value) {
            @strongify(self);
            return [self selectedSemesterId];
        }] distinctUntilChanged];
    }
    return self;
}

- (RACSignal *)fetchSemestersSignal
{
    @weakify(self);
    RACSignal *fetchSemestersSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            NSArray *semesterIds = [responseObject allKeys];
            NSMutableArray *semesterArray = [NSMutableArray arrayWithCapacity:semesterIds.count];
            for (id key in semesterIds) {
                XujcSemesterModel *semester = [[XujcSemesterModel alloc] init];
                semester.semesterId = key;
                semester.displayName = responseObject[key];
                [semesterArray addObject:semester];
            }
            
            [[CacheUtils instance] cacheSemesters:semesterArray];
            
            // sort DESC
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"semesterId" ascending:NO];
            self.semesters = [semesterArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            self.selectedIndex = 0;
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // load data from cache database
            self.semesters = [[CacheUtils instance] semestersFormCache];
            self.selectedIndex = 0;
            
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchSemestersSignal setNameWithFormat:@"fetchSemestersSignal"] logAll];
}

- (NSInteger)semesterCount
{
    return _semesters.count;
}

- (NSString *)selectedSemesterId
{
    return [_semesters objectAtIndex:_selectedIndex].semesterId;
}

- (NSString *)selectedSemesterName
{
    return [_semesters objectAtIndex:_selectedIndex].displayName;
}

- (SemesterTableViewCellViewModel *)semesterTableViewCellViewModelAtIndex:(NSInteger)index
{
    SemesterTableViewCellViewModel *viewModel = [[SemesterTableViewCellViewModel alloc] init];
    viewModel.semesterModel = [_semesters objectAtIndex:index];
    return viewModel;
}

@end
