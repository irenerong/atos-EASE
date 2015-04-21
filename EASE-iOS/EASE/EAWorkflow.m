//
//  EAWorkflow.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflow.h"
#import "NSMutableArray+Flags.h"
#import "EATask.h"

@implementation EAWorkflow

+(instancetype)workflowByParsingGeneratorDictionary:(NSDictionary*)dictionary
{
    
    return [[EAWorkflow alloc] initWithGeneratorDictionary:dictionary];
}

+(instancetype)workflowByParsingSearchDictionary:(NSDictionary*)dictionary completion:(void (^)(EAWorkflow *))completionBlock
{
    
    return [[EAWorkflow alloc] initWithSearchDictionary:dictionary completion:^(EAWorkflow *workflow) {
        completionBlock(workflow);
    }];
}


-(instancetype)initWithGeneratorDictionary:(NSDictionary*)dictionary
{
    
    if (self = [super init])
    {
        
        if (![dictionary isKindOfClass:[NSDictionary class]])
            return nil;
        
        self.isValidated = false;

        
        NSArray *tasks = dictionary[@"subtasks"];
        
        NSMutableArray *parsedTasks = [NSMutableArray array];
        
        for (NSDictionary *taskDic in tasks)
        {
            
            
            EATask *task = [EATask taskByParsingGeneratorDictionary:taskDic fromWorkflow:self];
            [parsedTasks addObject:task];
            
        }
        
        _tasks = parsedTasks;
        
    }
    
    return self;
    
}

-(instancetype)initWithSearchDictionary:(NSDictionary*)dictionary completion:(void (^)(EAWorkflow *))completionBlock
{
    if (self = [super init])
    {
        
        if (![dictionary isKindOfClass:[NSDictionary class]])
            return nil;
        self.isValidated = true;
       self.workflowID =((NSNumber*)dictionary[@"id"]).intValue;
        
        NSArray *tasks = dictionary[@"subtasks"];
        
        NSMutableArray *parsedTasks = [NSMutableArray array];
        
        NSMutableArray *flags = [[NSMutableArray alloc] initWithFlags:tasks.count];
        for (int i = 0; i < tasks.count; i++)
        {
            NSDictionary *taskDic = tasks[i];
            
            [EATask taskByParsingSearchDictionary:taskDic fromWorkflow:self completion:^(EATask *task) {
                
                [parsedTasks addObject:task];
                [flags raiseFlag:i];
                
                if (flags.allFlagsRaised)
                    completionBlock(self);
                
                
            }];
            
        }
        
        _tasks = parsedTasks;
        
    }
    
    return self;
}

-(int)availableIngredients {
    int nb = 0;
    for (EAIngredient *ingredient in _ingredients)
        nb+=ingredient.available;
    
    return nb;
    
}

-(int)availableAgents
{
    int nb = 0;
    for (EAAgent *agent in _agents)
        nb+=(agent.name != nil);
    
    return nb;

}

-(EADateInterval*)dateInterval
{
    if (!self.tasks.count)
        return nil;
    
    EATask *firstTask = self.tasks.firstObject;
    
    NSDate *start = firstTask.dateInterval.startDate;
    NSDate *end = firstTask.dateInterval.endDate;
    
    for (EATask *task in self.tasks)
    {
        
        if ([task.dateInterval.startDate compare:start] == NSOrderedAscending)
            start = task.dateInterval.startDate;
        
        if ([task.dateInterval.endDate compare:end] == NSOrderedDescending)
            end = task.dateInterval.endDate;

    }
    
    
    EADateInterval *dateInterval = [[EADateInterval alloc] init];
    dateInterval.startDate = start;
    dateInterval.endDate = end;
    
    return dateInterval;
    
}

-(NSString*)title
{
    return self.metaworkflow.title;
}

-(NSArray*)tasksAtDate:(NSDate*)date
{
    
    NSDate *tomorrow = [date dateByAddingTimeInterval:24*3600];
    EADateInterval *dateInterval = [EADateInterval dateIntervalFrom:date to:tomorrow];
    
    return [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EATask *task, NSDictionary *bindings) {
        
        return [task.dateInterval intersects:dateInterval];
        
    }]];
}

-(NSArray*)pendingTasks
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (EATask *task in self.tasks)
        if (task.status == EATaskStatusPending)
            [array addObject:task];
    
    return array;
}

-(void)updateWithWorkflow:(EAWorkflow*)workflow
{
    _isValidated = workflow.isValidated;
    _title = workflow.title;
    _ingredients = workflow.ingredients;

    for (EATask *task in workflow.tasks)
    {
        
        NSUInteger indexTask = [_tasks indexOfObjectPassingTest:^BOOL(EATask *t, NSUInteger idx, BOOL *stop) {
           
            return task.taskID == t.taskID;
            
        }];
        
        
        if (indexTask == NSNotFound)
        {
            [self.tasks addObject:task];
        }
        else
        {
            [((EATask*)self.tasks[indexTask]) updateWithTask:task];
        }
        
    }
    
}

@end
