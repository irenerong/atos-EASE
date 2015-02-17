//
//  EADateInterval.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EADateInterval.h"

@implementation EADateInterval

-(NSTimeInterval)timeInterval
{
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

-(BOOL)intersects:(EADateInterval*)dateInterval
{
    
    return ! (( [self.startDate compare:dateInterval.startDate] == NSOrderedDescending &&  ([self.startDate compare:dateInterval.endDate] == NSOrderedDescending || [self.startDate compare:dateInterval.endDate] == NSOrderedSame) ) || ( ( [self.endDate compare:dateInterval.startDate] == NSOrderedAscending || [self.endDate compare:dateInterval.startDate] == NSOrderedSame) &&  [self.endDate compare:dateInterval.endDate] == NSOrderedAscending ) );
    
    
}

@end
