//
//  NSDate+JSParse.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+JSParse.h"

@implementation NSDate (JSParse)

+ (instancetype) dateByParsingJSString:(NSString*)JSString
{
        
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    
    return [dateFormat dateFromString:JSString];
}



@end
