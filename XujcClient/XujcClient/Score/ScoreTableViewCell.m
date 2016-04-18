//
//  ScoreTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "XujcScoreModel.h"

static const CGFloat kFontSize = 12.f;
static const CGFloat kContentEdgeInsetVertical = 8.f;
static const CGFloat kContentEdgeHorizontal = 12.f;

static const CGFloat kContentMarginHorizontal = 5.f;

@interface ScoreTableViewCell()

@property (strong, nonatomic) UILabel *lessonNameLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *lessonDetailView;
@property (strong, nonatomic) UILabel *detailStudyWayLabel;
@property (strong, nonatomic) UILabel *creditLabel;

@end

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lessonNameLabel = [[UILabel alloc] init];
        _lessonNameLabel.textColor = [UIColor ty_textBlack];
        _lessonNameLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_lessonNameLabel];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        _scoreLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_scoreLabel];
        
        _lessonDetailView = [[UIView alloc] init];
        _lessonDetailView.backgroundColor = [UIColor ty_backgroundHighlight];
        [self.contentView addSubview:_lessonDetailView];
        
        _detailStudyWayLabel = [[UILabel alloc] init];
        _detailStudyWayLabel.textColor = [UIColor ty_textBlack];
        _detailStudyWayLabel.font = [UIFont systemFontOfSize:kFontSize];
        _detailStudyWayLabel.numberOfLines = 0;
        [_lessonDetailView addSubview:_detailStudyWayLabel];
        
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textColor = [UIColor ty_textBlack];
        _creditLabel.font = [UIFont systemFontOfSize:kFontSize];
        [_lessonDetailView addSubview:_creditLabel];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(kContentMarginHorizontal);
            make.trailing.equalTo(self).with.offset(-kContentMarginHorizontal);
        }];
        
        @weakify(self);
        [_scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.trailing.equalTo(self.contentView).offset(-kContentEdgeHorizontal);
            make.height.equalTo(self.lessonNameLabel);
            make.top.equalTo(self.lessonNameLabel);
        }];
        
        [_lessonDetailView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.contentView);
            make.leading.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
        [_detailStudyWayLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.lessonDetailView.mas_top).with.offset(kContentEdgeInsetVertical);
            make.trailing.equalTo(self.lessonDetailView);
            make.leading.equalTo(self.lessonNameLabel);
        }];
        
        [_creditLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.detailStudyWayLabel.mas_bottom);
            make.trailing.equalTo(self.lessonDetailView);
            make.leading.equalTo(self.lessonNameLabel);
            make.bottom.equalTo(self.lessonDetailView.mas_bottom).with.offset(-kContentEdgeInsetVertical);
        }];
        
        [_lessonNameLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView).offset(kContentEdgeHorizontal);
            make.top.equalTo(self.contentView).offset(kContentEdgeInsetVertical);
            make.right.equalTo(self.scoreLabel.mas_left).with.offset(-kContentEdgeInsetVertical);
            make.bottom.equalTo(_lessonDetailView.mas_top).with.offset(-kContentEdgeInsetVertical);
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
    RACSignal *scoreSignal = [RACObserve(self.viewModel, score) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_scoreLabel, text) = [scoreSignal map:^id(NSNumber *value) {
        return [value stringValue];
    }];
    
    RAC(_scoreLabel, textColor) = [scoreSignal map:^id(NSNumber *value) {
        return [value integerValue] > 59 ? [UIColor ty_textGreen] : [UIColor ty_textRed];
    }];
    
    RAC(_lessonNameLabel, text) = [RACObserve(self.viewModel, lessonName) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_detailStudyWayLabel, text) = [[RACObserve(self.viewModel, studyWay) map:^id(NSString *value) {
        return [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"StudyWay", nil), value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_creditLabel, text) = [[RACObserve(self.viewModel, credit) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Credit", nil), (long)[value integerValue]];
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end