//
//  NSDate+JSParse.h
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Complements
                   )

+ (instancetype)dateByParsingJSString:(NSString *)JSString;


+ (NSString *)lateFromDate:(NSDate *)date;

+ (NSString *)timeLeftMessage:(NSTimeInterval)timeInterval;

@end
