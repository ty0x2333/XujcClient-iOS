//
//  SemesterBaseViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterBaseViewController.h"
#import "SemesterSelectorView.h"

@interface SemesterBaseViewController()

@property (strong, nonatomic) UIButton *semesterButton;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@property (strong, nonatomic) SemesterSelectorView *semesterSelectorView;

@property (strong, nonatomic) SemesterBaseViewModel *viewModel;

@end

@implementation SemesterBaseViewController

- (instancetype)initWithViewModel:(SemesterBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _semesterButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(200, 0)}];
    [_semesterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = _semesterButton;
    @weakify(self);
    _semesterButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([self.dropdownView isOpen]) {
            [self.dropdownView hide];
        } else {
            self.dropdownView.contentBackgroundColor = [UIColor ty_backgroundHighlight];
            [self.dropdownView showInView:self.navigationController.visibleViewController.view withContentView:self.semesterSelectorView atOrigin:CGPointMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        }
        return [RACSignal empty];
    }];
    
    _semesterSelectorView = [[SemesterSelectorView alloc] initWithViewModel:self.viewModel.semesterSelectorViewModel];
    _semesterSelectorView.backgroundColor = [UIColor redColor];
    
    _dropdownView = [[LMDropdownView alloc] init];
    //    self.dropdownView.closedScale = 0.85;
    //    self.dropdownView.blurRadius = 5;
    //    self.dropdownView.blackMaskAlpha = 0.5;
    //    self.dropdownView.animationDuration = 0.5;
    //    self.dropdownView.animationBounceHeight = 20;
    
    [self.viewModel.semesterSelectorViewModel.selectedSemesterNameSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        [self.semesterButton setTitle:value forState:UIControlStateNormal];
        [self.dropdownView hide];
    }];
}

@end
