//
//  UserDetailViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UserDetailViewModel.h"
#import "DynamicData.h"
#import "XujcUserModel.h"
#import "XujcInformationViewModel.h"
#import "TYService.h"

@interface UserDetailViewModel()

@property (nonatomic, strong) XujcUserModel *xujcUserModel;

@end

@implementation UserDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _xujcUserModel = [[XujcUserModel alloc] init];
        @weakify(self);
        _fetchXujcInformationSignal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            return [[self.xujcSessionManager requestUserInformationSignalWithXujcKey:DYNAMIC_DATA.xujcKey] subscribeNext:^(XujcUserModel *model) {
                self.xujcUserModel.studentId = model.studentId;
                self.xujcUserModel.name = model.name;
                self.xujcUserModel.grade = model.grade;
                self.xujcUserModel.major = model.major;
                [subscriber sendNext:model];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
        }];
        _fetchProfileSignal = [self.sessionManager requestProfileSignal];
    }
    return self;
}

- (XujcInformationViewModel *)xujcInformationViewModel
{
    return [[XujcInformationViewModel alloc] initWithModel:_xujcUserModel];
}

@end
