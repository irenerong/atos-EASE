//
//  EATask.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+Complements.h"

#import "EATask.h"

#import "EADateInterval.h"
#import "EAAgent.h"

@implementation EATask


+(instancetype)taskByParsingGeneratorDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow
{
    return [[EATask alloc] initWithGeneratorDictionary:dictionary fromWorkflow:workflow];
}


+(instancetype)taskByParsingSearchDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow completion:(void (^)(EATask *))completionBlock
{
    return [[EATask alloc] initWithSearchDictionary:dictionary fromWorkflow:workflow completion:^(EATask *task) {
        completionBlock(task);
    }];
}

-(instancetype)initWithGeneratorDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow
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


-(instancetype)initWithSearchDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow completion:(void (^)(EATask *))completionBlock
{
    if (self = [super init])
    {
        
        _workflow = workflow;
        
        
        
        
        _taskID = ((NSString*)dictionary[@"id"]).intValue;
        
        
        if ([dictionary[@"status"] isEqualToString:@"working"])
            self.status = EATaskStatusWorking;
        else if ([dictionary[@"status"] isEqualToString:@"waiting"])
            self.status = EATaskStatusWaiting;
        else if ([dictionary[@"status"] isEqualToString:@"pending"])
            self.status = EATaskStatusPending;
        
        int startConditionID = ((NSString*)dictionary[@"startCondition"]).intValue;
        
        EAAgent *agent = [[EAAgent alloc] init];
        agent.agentID = ((NSString*)dictionary[@"agentID"]).intValue;
        
        [[EANetworkingHelper sharedHelper] retrieveStartConditionWithID:startConditionID completionBlock:^(NSDictionary *startCondition, NSError *error) {
           
            _predecessors = startCondition[@"waitforID"];
            
            
            
            NSDate *beginTime = [NSDate dateByParsingJSString:startCondition[@"startDate"]];
            float duration =  ((NSString*)dictionary[@"duration"]).intValue;
            NSDate *endTime = [beginTime dateByAddingTimeInterval:duration*60];
            _dateInterval = [EADateInterval dateIntervalFrom:beginTime to:endTime];
            
            completionBlock(self);
            
        }];
        
        
        
        
        
        
    }
    return self;

}

-(void)updateWithTask:(EATask*)task
{
    
    _dateInterval = task.dateInterval;
    _status = task.status;
}

@end
