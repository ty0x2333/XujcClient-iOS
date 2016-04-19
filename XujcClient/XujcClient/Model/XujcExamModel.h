//
//  XujcExamModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BaseModel.h"

@interface XujcExamModel : BaseModel

@property (nonatomic, copy) NSString* lessonName;
@property (nonatomic, copy) NSString* location;

@property (nonatomic, copy) NSString* startDate;
@property (nonatomic, copy) NSString* timePeriod;
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* way;
@property (nonatomic, copy) NSString* week;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* status;

@end
