//
//  ChangePasswordViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ChangePasswordViewController.h"

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Change Password Screen";
    self.title = NSLocalizedString(@"Change Password", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
