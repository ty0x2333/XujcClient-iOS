//
//  AvatarImageView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/25.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AvatarImageView.h"

@implementation AvatarImageView

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self commontInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commontInit];
    }
    return self;
}

- (void)commontInit
{
    self.layer.masksToBounds = YES;
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_height);
    }];
    RAC(self, layer.cornerRadius) = [[[RACSignal merge:@[RACObserve(self, frame), RACObserve(self, bounds)]] distinctUntilChanged]
                                     map:^(NSValue *value) {
                                         return @(CGRectGetWidth([value CGRectValue]) / 2.f);
                                     }];
}

@end
