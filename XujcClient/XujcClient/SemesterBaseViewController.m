//
//  SemesterBaseViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterBaseViewController.h"
#import "SemesterSelectorView.h"

static CGFloat const kArrowImageViewSize = 18.f;
static CGFloat const kSemesterLabelFontSize = 14.f;

@interface SemesterBaseViewController()<LMDropdownViewDelegate>

@property (strong, nonatomic) UIButton *semesterButton;

@property (strong, nonatomic) UILabel *semesterLabel;

@property (strong, nonatomic) UIImageView *arrowImageView;

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
    _semesterButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(200, CGRectGetHeight(self.navigationController.navigationBar.bounds))}];
    
    _semesterLabel = [[UILabel alloc] init];
    _semesterLabel.font = [UIFont systemFontOfSize:kSemesterLabelFontSize];
    [_semesterButton addSubview:_semesterLabel];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    [_semesterButton addSubview:_arrowImageView];
    
    [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.semesterLabel.mas_left);
        make.centerY.equalTo(self.semesterButton);
        make.height.width.equalTo(@(kArrowImageViewSize));
    }];
    
    [_semesterLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.semesterButton);
    }];
    
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
    _dropdownView.delegate = self;
    //    self.dropdownView.closedScale = 0.85;
    //    self.dropdownView.blurRadius = 5;
    //    self.dropdownView.blackMaskAlpha = 0.5;
    //    self.dropdownView.animationDuration = 0.5;
    //    self.dropdownView.animationBounceHeight = 20;
    
    [self.viewModel.semesterSelectorViewModel.selectedSemesterNameSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        self.semesterLabel.text = value;
        [self.dropdownView hide];
    }];
}

#pragma mark - LMDropdownViewDelegate

- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView
{
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
}

- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView
{
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
}

@end
