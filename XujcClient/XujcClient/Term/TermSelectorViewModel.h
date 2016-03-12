//
//  TermSelectorViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "XujcTerm.h"
#import "TermTableViewCellViewModel.h"

@interface TermSelectorViewModel : RequestViewModel

@property (strong, nonatomic) RACSignal *fetchTermsSignal;

@property (strong, nonatomic) RACSignal *selectedTermNameSignal;

@property (assign, nonatomic) NSInteger selectedIndex;

- (NSInteger)termCount;

- (NSString *)selectedTermId;

- (TermTableViewCellViewModel *)termTableViewCellViewModelAtIndex:(NSInteger)index;

@end
