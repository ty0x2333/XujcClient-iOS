//
//  TableViewCellViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewCellViewModel : NSObject

@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;

@property (copy, nonatomic) NSString *imageNamed;

@property (copy, nonatomic) NSString *localizedText;

@end
