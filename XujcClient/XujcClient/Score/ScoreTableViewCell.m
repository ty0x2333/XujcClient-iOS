//
//  ScoreTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "XujcScore.h"

static const CGFloat kFontSize = 12.f;
static const CGFloat kContentEdgeInsetVertical = 8.f;
static const CGFloat kContentEdgeHorizontal = 12.f;

static const CGFloat kBorderWith = .5f;
static const CGFloat kCornerRadius = 4.f;

static const CGFloat kContentMarginHorizontal = 5.f;

@interface ScoreTableViewCell()

@property (strong, nonatomic) UILabel *courseNameLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *courseDetailView;
@property (strong, nonatomic) UILabel *detailStudyWayLabel;
@property (strong, nonatomic) UILabel *creditLabel;

@end

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.contentView.layer.borderColor = [UIColor ty_border].CGColor;
        self.contentView.layer.borderWidth = kBorderWith;
        self.contentView.layer.cornerRadius = kCornerRadius;
        self.contentView.layer.masksToBounds = true;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = [UIColor ty_textBlack];
        _courseNameLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_courseNameLabel];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        _scoreLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_scoreLabel];
        
        _courseDetailView = [[UIView alloc] init];
        _courseDetailView.backgroundColor = [UIColor ty_backgroundHighlight];
        [self.contentView addSubview:_courseDetailView];
        
        _detailStudyWayLabel = [[UILabel alloc] init];
        _detailStudyWayLabel.textColor = [UIColor ty_textBlack];
        _detailStudyWayLabel.font = [UIFont systemFontOfSize:kFontSize];
        _detailStudyWayLabel.numberOfLines = 0;
        [_courseDetailView addSubview:_detailStudyWayLabel];
        
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textColor = [UIColor ty_textBlack];
        _creditLabel.font = [UIFont systemFontOfSize:kFontSize];
        [_courseDetailView addSubview:_creditLabel];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(kContentMarginHorizontal);
            make.trailing.equalTo(self).with.offset(-kContentMarginHorizontal);
        }];
        
        @weakify(self);
        [_scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.trailing.equalTo(self.contentView).offset(-kContentEdgeHorizontal);
            make.height.equalTo(self.courseNameLabel);
            make.top.equalTo(self.courseNameLabel);
        }];
        
        [_courseDetailView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.contentView);
            make.leading.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
        [_detailStudyWayLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.courseDetailView.mas_top).with.offset(kContentEdgeInsetVertical);
            make.trailing.equalTo(self.courseDetailView);
            make.leading.equalTo(self.courseNameLabel);
        }];
        
        [_creditLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.detailStudyWayLabel.mas_bottom);
            make.trailing.equalTo(self.courseDetailView);
            make.leading.equalTo(self.courseNameLabel);
            make.bottom.equalTo(self.courseDetailView.mas_bottom).with.offset(-kContentEdgeInsetVertical);
        }];
        
        [_courseNameLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView).offset(kContentEdgeHorizontal);
            make.top.equalTo(self.contentView).offset(kContentEdgeInsetVertical);
            make.right.equalTo(self.scoreLabel.mas_left).with.offset(-kContentEdgeInsetVertical);
            make.bottom.equalTo(_courseDetailView.mas_top).with.offset(-kContentEdgeInsetVertical);
        }];
    }
    return self;
}

- (void)setViewModel:(ScoreTableViewCellViewModel *)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    _viewModel = viewModel;
    RACSignal *scoreSignal = [RACObserve(self.viewModel, xujcScoreModel.score) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_scoreLabel, text) = [scoreSignal map:^id(NSNumber *value) {
        return [value stringValue];
    }];
    
    RAC(_scoreLabel, textColor) = [scoreSignal map:^id(NSNumber *value) {
        return [value integerValue] > 59 ? [UIColor ty_textGreen] : [UIColor ty_textRed];
    }];
    
    RAC(_courseNameLabel, text) = [RACObserve(self.viewModel, xujcScoreModel.courseName) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_detailStudyWayLabel, text) = [[RACObserve(self.viewModel, xujcScoreModel.studyWay) map:^id(NSString *value) {
        return [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"StudyWay", nil), value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_creditLabel, text) = [[RACObserve(self.viewModel, xujcScoreModel.credit) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Credit", nil), (long)[value integerValue]];
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end