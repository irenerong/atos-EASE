//
//  NSDate+JSParse.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+Complements.h"

@implementation NSDate (Complements)

+ (instancetype)dateByParsingJSString:(NSString *)JSString {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];


    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

    return [dateFormat dateFromString:JSString];
}

+ (NSString *)lateFromDate:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];

    BOOL late = false;


    if (timeInterval < 0) {
        late          = true;
        timeInterval *= -1;
    }


    NSString *string = [NSDate timeLeftMessage:timeInterval];


    if (late)
        string = [NSString stringWithFormat:@"%@ late", string];

    else
        string = [NSString stringWithFormat:@"In %@", string];

    return string;

}

+ (NSString *)timeLeftMessage:(NSTimeInterval)timeInterval {
    NSString *string = @"";

    timeInterval /= 60;

    int minutes = (int)timeInterval % 60;
    timeInterval /= 60;

    int hours = (int)timeInterval % 24;
    timeInterval /= 24;

    int days = timeInterval;


    if (days != 0)
        string = [NSString stringWithFormat:@"%dd ", days];
    if (hours != 0)
        string = [string stringByAppendingFormat:@"%dh ", hours];

    return [string stringByAppendingFormat:@"%dm", minutes];


}

@end
