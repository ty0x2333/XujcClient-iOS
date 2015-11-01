/**
 * @file BaseModel.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (instancetype)initWithJSONResopnse:(NSDictionary *)json;

/**
 *  Method to check if a value is null
 *
 *  @param value The value to be checked
 *
 *  @return Returns nil if value is null otherwise the value
 */
- (id)checkForNull:(id)value;

- (NSData *)data;

@end
