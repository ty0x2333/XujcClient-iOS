//
//  MSEvent.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSEvent.h"

@implementation MSEvent

- (NSDate *)day
{
    return [[NSCalendar currentCalendar] startOfDayForDate:self.start];
}

@end
