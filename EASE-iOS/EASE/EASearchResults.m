//
//  EASearchResults.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchResults.h"

@implementation EASearchResults



+(instancetype)searchResultsByParsingDictionary:(NSDictionary*)dictionnary
{
    return [[EASearchResults alloc] initWithDictionary:dictionnary];
}


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
    if (self = [super init])
    {
        
        
        NSArray *workflows = dictionary[@"workflows"];
        NSMutableArray *parsedWorkflows = [NSMutableArray array];
        
        
        if (!workflows)
            return nil;
        
        for (int i = 0; i < workflows.count; i++)
        {
            NSDictionary *workflowDic = workflows[i];
            EAWorkflow *workflow = [EAWorkflow workflowByParsingDictionary:workflowDic];
            workflow.workflowID = i;
            
            [parsedWorkflows addObject:workflow];
            
        }
        
        _workflows = parsedWorkflows;
        
        
        
    }
    
    return self;
    
}


@end
