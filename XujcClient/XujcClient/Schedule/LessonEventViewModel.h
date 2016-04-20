//
//  LessonEventViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XujcLessonEventModel;

@interface LessonEventViewModel : NSObject

- (instancetype)initWithModel:(XujcLessonEventModel *)model;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *location;

@end
