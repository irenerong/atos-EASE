//
//  EAWorkflow.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflow.h"

#import "EATask.h"

@implementation EAWorkflow

+(instancetype)workflowByParsingDictionary:(NSDictionary*)dictionary
{
    
    return [[EAWorkflow alloc] initWithDictionary:dictionary];
}


-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    
    if (self = [super init])
    {
        
        if (![dictionary isKindOfClass:[NSDictionary class]])
            return nil;
        
        NSArray *tasks = dictionary[@"subtasks"];
        
        NSMutableArray *parsedTasks = [NSMutableArray array];
        
        for (NSDictionary *taskDic in tasks)
        {
            
            
            EATask *task = [EATask taskByParsingDictionary:taskDic fromWorkflow:self];
            [parsedTasks addObject:task];
            
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



@end
