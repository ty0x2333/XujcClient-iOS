//
//  ScoreTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "XujcScore.h"
#import "UIView+BorderLine.h"

static const CGFloat kFontSize = 12.f;
static const CGFloat kContentEdgeInsetVertical = 8.f;
static const CGFloat kContentEdgeHorizontal = 12.f;
static const CGFloat kArrowSize = 16.f;

@interface ScoreTableViewCell()

@property (strong, nonatomic) UILabel *courseNameLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIView *courseDetailView;
@property (strong, nonatomic) UILabel *detailStudyWayLabel;
@property (strong, nonatomic) UILabel *creditLabel;
@end

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.ty_borderEdge = UIRectEdgeBottom;
        self.ty_borderColor = [UIColor blackColor].CGColor;
        self.ty_borderWidth = 0.2f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = [UIColor ty_textBlack];
        _courseNameLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_courseNameLabel];
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:_arrowImageView];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        _scoreLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_scoreLabel];
        
        _courseDetailView = [[UIView alloc] init];
        _courseDetailView.hidden = YES;
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
        
        _detailHidden = YES;
        
        @weakify(self);
        
        [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView).offset(kContentEdgeHorizontal);
            make.height.equalTo(@(kArrowSize));
            make.width.equalTo(self.arrowImageView.height);
            make.top.equalTo(self.courseNameLabel);
        }];
        
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
        
        [RACObserve(self, detailHidden) subscribeNext:^(NSNumber *value) {
            BOOL hidden = [value boolValue];
            _courseDetailView.hidden = hidden;
            _arrowImageView.image = [UIImage imageNamed:hidden ? @"arrow_right" : @"arrow_down"];
            [_courseNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.arrowImageView.mas_right);
                make.top.equalTo(self.contentView).offset(kContentEdgeInsetVertical);
                make.right.equalTo(self.scoreLabel.mas_left).with.offset(-kContentEdgeInsetVertical);
                if (hidden) {
                    make.bottom.equalTo(self.contentView).with.offset(-kContentEdgeInsetVertical);
                } else {
                    make.bottom.equalTo(_courseDetailView.mas_top).with.offset(-kContentEdgeInsetVertical);
                }
            }];
            [super updateConstraints];
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