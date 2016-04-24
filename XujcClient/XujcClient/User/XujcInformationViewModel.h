//
//  XujcInformationViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XujcUserModel;

@interface XujcInformationViewModel : NSObject

- (instancetype)initWithModel:(XujcUserModel *)model;

@property (nonatomic, readonly, strong) NSString *studentId;
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSString *grade;
@property (nonatomic, readonly, strong) NSString *professional;

@end
