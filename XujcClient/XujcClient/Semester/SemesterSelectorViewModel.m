//
//  SemesterSelectorViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterSelectorViewModel.h"

@interface SemesterSelectorViewModel()

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
        
        _semestersSignal = [[RACObserve(self, semesters) setNameWithFormat:@"SemesterSelectorViewModel semestersSignal"] logAll];
        
        [self.semestersSignal subscribeNext:^(id x) {
            @strongify(self);
            self.selectedIndex = 0;
        }];
    }
    return self;
}

- (NSString *)selectedSemesterId
{
    return [_semesters objectAtIndex:_selectedIndex].semesterId;
}

- (NSString *)selectedSemesterName
{
    return [_semesters objectAtIndex:_selectedIndex].displayName;
}

- (NSInteger)semesterCount
{
    return _semesters.count;
}

- (SemesterTableViewCellViewModel *)semesterTableViewCellViewModelAtIndex:(NSInteger)index
{
    SemesterTableViewCellViewModel *viewModel = [[SemesterTableViewCellViewModel alloc] init];
    viewModel.semesterModel = [_semesters objectAtIndex:index];
    return viewModel;
}

@end
