//
//  TermBaseViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermBaseViewController.h"
#import "TermSelectorView.h"

@interface TermBaseViewController()

@property (strong, nonatomic) UIButton *termButton;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@property (strong, nonatomic) TermSelectorView *termSelectorView;

@property (strong, nonatomic) TermBaseViewModel *viewModel;

@end

@implementation TermBaseViewController

- (instancetype)initWithViewModel:(TermBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _termButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(200, 0)}];
    [_termButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = _termButton;
    @weakify(self);
    _termButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        TyLogDebug(@"term button clicked");
        if ([self.dropdownView isOpen]) {
            [self.dropdownView hide];
        } else {
            self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
            [self.dropdownView showInView:self.navigationController.visibleViewController.view withContentView:self.termSelectorView atOrigin:CGPointMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        }
        return [RACSignal empty];
    }];
    
    _termSelectorView = [[TermSelectorView alloc] initWithViewModel:self.viewModel.termSelectorViewModel];
    _termSelectorView.backgroundColor = [UIColor redColor];
    
    _dropdownView = [[LMDropdownView alloc] init];
    //    self.dropdownView.closedScale = 0.85;
    //    self.dropdownView.blurRadius = 5;
    //    self.dropdownView.blackMaskAlpha = 0.5;
    //    self.dropdownView.animationDuration = 0.5;
    //    self.dropdownView.animationBounceHeight = 20;
    
    [self.viewModel.termSelectorViewModel.selectedTermNameSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        [self.termButton setTitle:value forState:UIControlStateNormal];
        [self.dropdownView hide];
    }];
}

@end
