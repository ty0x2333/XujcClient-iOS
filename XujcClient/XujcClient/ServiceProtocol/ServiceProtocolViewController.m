//
//  ServiceProtocolViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/22.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ServiceProtocolViewController.h"

@interface ServiceProtocolViewController()

@property (nonatomic, strong) ServiceProtocolViewModel *viewModel;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ServiceProtocolViewController

- (instancetype)initWithViewModel:(ServiceProtocolViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Service Protocol Screen";
    self.title = NSLocalizedString(@"Service Protocol", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:_viewModel.urlRequest];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
