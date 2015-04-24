//
//  EASearchResults.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchResults.h"

@implementation EASearchResults



+(instancetype)searchResultsByParsingGeneratorDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock
{
    return [[EASearchResults alloc] initWithGeneratorDictionary:dictionary completion:^(EASearchResults *searchResult) {
        completionBlock(searchResult);
    }];
}

+(instancetype)searchResultsByParsingSearchDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock
{
    return [[EASearchResults alloc] initWithSearchDictionary:dictionary completion:^(EASearchResults *searchResult) {
        completionBlock(searchResult);
    }];
}


-(instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary completion:(void (^) (EASearchResults *))completionBlock
{
    
    if (self = [super init])
    {
        
        
        NSArray *workflows = dictionary[@"workflows"];
        NSLog(@"%@", workflows);
        
        if (!workflows.count)
        {
            completionBlock(nil);
            return nil;
        }
        NSMutableArray *parsedWorkflows = [NSMutableArray array];
        NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
        NSMutableArray *parsedAgents = [NSMutableArray array];

        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        _agents = parsedAgents;
        
        NSMutableDictionary *metaworkflowsLink = [NSMutableDictionary dictionary];
        NSMutableDictionary *agentsLink = [NSMutableDictionary dictionary];

      
        
        
        for (int i = 0; i < workflows.count; i++)
        {
            
            
            
            NSDictionary *workflowDic = workflows[i];
            
            
            EAWorkflow *workflow = [EAWorkflow workflowByParsingGeneratorDictionary:workflowDic];
            if (!workflow)
            {
                break;
                
            }
            workflow.workflowID = i;
            
            
            
            [parsedWorkflows addObject:workflow];
            
            
            
            
            int metaworkflowID = ((NSNumber*)workflowDic[@"metaworkflow"]).intValue;
            
            if (metaworkflowsLink[@(metaworkflowID)])
            {
                [((NSMutableArray*)metaworkflowsLink[@(metaworkflowID)]) addObject:workflow];
            }
            else
                metaworkflowsLink[@(metaworkflowID)] = [NSMutableArray arrayWithObject:workflow];
            
            
            for (EATask *task in workflow.tasks)
            {
                int agentID = task.agentID;
                
                
                if (agentsLink[@(agentID)])
                {
                    [((NSMutableArray*)agentsLink[@(agentID)]) addObject:task];
                }
                else
                    agentsLink[@(agentID)] = [NSMutableArray arrayWithObject:task];
            }
            
            
        }
        
        
        
        dispatch_group_t group = dispatch_group_create();
        
        for (NSNumber *metaworkflowID in metaworkflowsLink.allKeys)
        {
            
            dispatch_group_enter(group);
            
            [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID.intValue completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
                
                for (EAWorkflow *workflow in metaworkflowsLink[metaworkflowID])
                    workflow.metaworkflow = metaworkflow;
                
                [parsedMetaworkflows addObject:metaworkflow];
                
                dispatch_group_leave(group);
                
            }];
            
        }
        
        for (NSNumber *agentID in agentsLink)
        {
            dispatch_group_enter(group);

            [[EANetworkingHelper sharedHelper] retrieveAgentWithID:agentID completionBlock:^(EAAgent *agent, NSError *error) {
               
                for (EATask *task in agentsLink[agentID])
                    task.agent = agent;
                
                [parsedAgents addObject:agent];
                
                dispatch_group_leave(group);
                
            }];
            
        }
        
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            completionBlock(self);
            
        });
        
        
    }
    
    return self;
    
}


-(instancetype)initWithSearchDictionary:(NSArray *)array completion:(void (^) (EASearchResults *searchResult))completionBlock
{
    if (self = [super init])
    {
        NSMutableArray *parsedWorkflows = [NSMutableArray array];
        NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
        NSMutableArray *parsedAgents = [NSMutableArray array];

        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        _agents = parsedAgents;
        
        NSMutableDictionary *metaworkflowsLink = [NSMutableDictionary dictionary];
        NSMutableDictionary *agentsLink = [NSMutableDictionary dictionary];

        NSMutableArray *workflowsIDs = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary *subtask, NSUInteger idx, BOOL *stop) {
            
            int workflowID;
            
            if (subtask[@"WORKFLOW"])
                workflowID = ((NSNumber*)subtask[@"WORKFLOW"]).intValue;
            else if (subtask[@"workflow"])
                workflowID = ((NSNumber*)subtask[@"workflow"]).intValue;
            
            if( [workflowsIDs indexOfObjectPassingTest:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
                return obj.intValue == workflowID;
            }] == NSNotFound)
                
                [workflowsIDs addObject:@(workflowID)];
            
            
        }];
        
        
        dispatch_group_t group = dispatch_group_create();
        
        for (NSNumber *workflowID in workflowsIDs)
        {
            dispatch_group_enter(group);
            
            
            [[EANetworkingHelper sharedHelper] retrieveWorkflowWithID:workflowID.intValue completionBlock:^(EAWorkflow *workflow, int metaworkflowID, NSError *error) {
                
                
                [parsedWorkflows addObject:workflow];
                
                
                dispatch_group_t preGroup = dispatch_group_create();
                
                dispatch_group_enter(preGroup);
                
                if (metaworkflowsLink[@(metaworkflowID)])
                {
                    [((NSMutableArray*)metaworkflowsLink[@(metaworkflowID)]) addObject:workflow];
                    dispatch_group_leave(preGroup);
                }
                else
                {
                    metaworkflowsLink[@(metaworkflowID)] = [NSMutableArray arrayWithObject:workflow];
                    
                    [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
                        
                        [parsedMetaworkflows addObject:metaworkflow];
                        dispatch_group_leave(preGroup);
                        
                        
                    }];
                    
                }
                
                for (EATask *task in workflow.tasks)
                {
                    
                    dispatch_group_enter(preGroup);

                    
                    if (agentsLink[@(task.agentID)])
                    {
                        [((NSMutableArray*)agentsLink[@(task.agentID)]) addObject:task];
                        dispatch_group_leave(preGroup);
                    }
                    else
                    {
                        agentsLink[@(task.agentID)] = [NSMutableArray arrayWithObject:task];
                        
                        [[EANetworkingHelper sharedHelper] retrieveAgentWithID:task.agentID completionBlock:^(EAAgent *agent, NSError *error) {
                            
                        
                            
                            [parsedAgents addObject:agent];
                            dispatch_group_leave(preGroup);
                            
                            
                        }];
                        
                    }

                }
                
                
                
                
                
                dispatch_group_notify(preGroup, dispatch_get_main_queue(), ^{
                    
                   
                    
                    dispatch_group_leave(group);
                });
                
                
                
            }];
            
            
        }
        
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            for (EAMetaworkflow *metaworkflow in parsedMetaworkflows)
            {
                for (EAWorkflow *workflow in metaworkflowsLink[@(metaworkflow.metaworkflowID)])
                    workflow.metaworkflow = metaworkflow;
            }
            
            for (EAAgent *agent in parsedAgents)
            {
                for (EATask *task in agentsLink[@(agent.agentID)])
                    task.agent = agent;
            }
            
            completionBlock(self);
        });
        
        
    }
    
    return self;
}

-(void)updateWorkflowWithID:(int)workflowID completion:(void (^) () )completionBlock
{
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    
    [[EANetworkingHelper sharedHelper] retrieveWorkflowWithID:workflowID completionBlock:^(EAWorkflow *workflow, int metaworkflowID, NSError *error) {
        
        NSUInteger indexWorkflow = [_workflows indexOfObjectPassingTest:^BOOL(EAWorkflow *obj, NSUInteger idx, BOOL *stop) {
            return obj.workflowID == workflowID;
        }];
        
        if (indexWorkflow  == NSNotFound)
        {
            [_workflows addObject:workflow];
        }
        else
        {
            [((EAWorkflow*)_workflows[indexWorkflow]) updateWithWorkflow:workflow];
        }
        
        NSUInteger indexMetaworkflow = [_metaworkflows indexOfObjectPassingTest:^BOOL(EAMetaworkflow *obj, NSUInteger idx, BOOL *stop) {
            return obj.metaworkflowID == metaworkflowID;
        }];
        
        if (indexMetaworkflow == NSNotFound)
        {
            
            [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
                
                [_metaworkflows addObject:metaworkflow];
                workflow.metaworkflow = metaworkflow;
                
                dispatch_group_leave(group);
                
            }];
            
            
            
        }
        else
        {
            workflow.metaworkflow = _metaworkflows[indexMetaworkflow];
            dispatch_group_leave(group);
        }
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        completionBlock();
        
    });
}

-(void)updateTaskWithID:(int)taskID completion:(void (^) () )completionBlock
{
    NSUInteger indexWorkflow = [_workflows indexOfObjectPassingTest:^BOOL(EAWorkflow *workflow, NSUInteger idx, BOOL *stop) {
        
        return [workflow.tasks indexOfObjectPassingTest:^BOOL(EATask *task, NSUInteger idx, BOOL *stop) {
            
            return task.taskID == taskID;
            
        }] != NSNotFound;
        
        
        
    }];
    
    if (indexWorkflow == NSNotFound)
    {
        
        [[EANetworkingHelper sharedHelper] retrieveWorkflowIDWithTaskID:taskID completionBlock:^(int workflowID, NSError *error) {
            
            
            [self updateWorkflowWithID:workflowID completion:^{
                completionBlock();
                
            }];
            
        }];
        
    }
    else
    {
        [self updateWorkflowWithID:((EAWorkflow*)_workflows[indexWorkflow]).workflowID completion:^{
            completionBlock();
        }];
    }
    
}

-(void)updateTaskWithFeedback:(NSDictionary*)feedback completion:(void (^) ())completionBlock
{
    int taskID = ((NSNumber*)feedback[@"id"]).intValue;
    NSString *verb = feedback[@"verb"];
    
    if ([verb isEqualToString:@"updated"])
    {
        EATask *task;
        
        for (EAWorkflow *workflow in _workflows)
        {
            for (EATask *t in workflow.tasks )
            {
                if (t.taskID == taskID)
                {
                    task = t;
                    break;
                }
            }
            if (task)
                break;
            
        }
        
        
        if (task)
        {
            [task updateWithFeedback:feedback[@"data"]];
        }
        
        completionBlock();
        
    }
    else if ([verb isEqualToString:@"created"])
    {
        [self updateTaskWithID:taskID completion:^{
            completionBlock();
        }];
    }
    
}


@end
