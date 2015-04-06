//
//  EATask.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+JSParse.h"

#import "EATask.h"

#import "EADateInterval.h"
#import "EAAgent.h"

@implementation EATask


+(instancetype)taskByParsingDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow
{
    return [[EATask alloc] initWithDictionary:dictionary fromWorkflow:workflow];
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow
{
    
    if (self = [super init])
    {
        
        _workflow = workflow;
        _taskID = ((NSString*)dictionary[@"subTask"]).intValue;
        
        _predecessors = dictionary[@"predecessors"];
        
        EAAgent *agent = [[EAAgent alloc] init];
        agent.agentID = ((NSString*)dictionary[@"agentID"]).intValue;
        
        NSDate *beginTime = [NSDate dateByParsingJSString:dictionary[@"beginTime"]];
        float duration =  ((NSString*)dictionary[@"duration"]).intValue;
        NSDate *endTime = [beginTime dateByAddingTimeInterval:duration*60];
        _dateInterval = [EADateInterval dateIntervalFrom:beginTime to:endTime];
        
    }
    return self;
    
}

@end
