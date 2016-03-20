//
//  TableViewCellViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TableViewCellViewModel.h"

@implementation TableViewCellViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _accessoryType = UITableViewCellAccessoryNone;
        _selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

@end
