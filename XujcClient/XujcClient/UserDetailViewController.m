//
//  UserDetailViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailViewModel.h"

@interface UserDetailViewController()

@property (strong, nonatomic) UserDetailViewModel *viewModel;

@end

@implementation UserDetailViewController

- (instancetype)initWithViewModel:(UserDetailViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Personal Detail", nil);
}

@end
