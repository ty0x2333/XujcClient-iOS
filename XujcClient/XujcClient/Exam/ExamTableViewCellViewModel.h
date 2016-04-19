//
//  ExamTableViewCellViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/19.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XujcExamModel;

@interface ExamTableViewCellViewModel : NSObject

- (instancetype)initWithModel:(XujcExamModel *)model;

@property (nonatomic, readonly, copy) NSString* lessonName;
@property (nonatomic, readonly, copy) NSString* location;

@property (nonatomic, readonly, copy) NSString* dateDescription;
@property (nonatomic, readonly, copy) NSString* weekDescription;
@property (nonatomic, readonly, copy) NSString* way;
@property (nonatomic, readonly, copy) NSString* name;
@property (nonatomic, readonly, copy) NSString* status;

@end
