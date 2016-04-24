/**
 * @file XujcUserModel.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"

@interface XujcUserModel : BaseModel

@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, strong) NSString *professional;

@end
