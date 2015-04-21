//
//  EASearchResults.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchResults.h"
#import "NSMutableArray+Flags.h"

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
        
        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        
        NSMutableDictionary *metaworkflowsLink = [NSMutableDictionary dictionary];
        
        if (!workflows)
        {
            return nil;
            
        }
        
        
        
        
        
        
        
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
        
        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        
        NSMutableDictionary *metaworkflowsLink = [NSMutableDictionary dictionary];
        
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
                
                if (metaworkflowsLink[@(metaworkflowID)])
                {
                    [((NSMutableArray*)metaworkflowsLink[@(metaworkflowID)]) addObject:workflow];
                    dispatch_group_leave(group);
                }
                else
                {
                    metaworkflowsLink[@(metaworkflowID)] = [NSMutableArray arrayWithObject:workflow];
                    
                    [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
                       
                        [parsedMetaworkflows addObject:metaworkflow];
                        dispatch_group_leave(group);

                        
                    }];
                    
                }
                
                
            }];
            
            
        }
        
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{

            for (EAMetaworkflow *metaworkflow in parsedMetaworkflows)
            {
                for (EAWorkflow *workflow in metaworkflowsLink[@(metaworkflow.metaworkflowID)])
                    workflow.metaworkflow = metaworkflow;
            }
            
            completionBlock(self);
        });
        
        
    }
    
    return self;
}

@end
