/**
 * @file XujcUser.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"

@interface XujcUser : BaseModel

@property(nonatomic, strong)NSString *studentId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *grade;
@property(nonatomic, strong)NSString *professional;

@end
