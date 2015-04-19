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



/*-(instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary completion:(void (^) (EASearchResults *))completionBlock
 {
 
 if (self = [super init])
 {
 
 
 NSArray *workflows = dictionary[@"workflows"];
 NSLog(@"%@", workflows);
 NSMutableArray *parsedWorkflows = [NSMutableArray array];
 NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
 
 
 
 if (!workflows)
 {
 return nil;
 
 }
 
 dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
 dispatch_queue_t queue = dispatch_queue_create("com.EASE.task", NULL);
 
 NSMutableArray *flags = [[NSMutableArray alloc] initWithFlags:workflows.count];
 
 
 for (int i = 0; i < workflows.count; i++)
 {
 NSDictionary *workflowDic = workflows[i];
 
 
 EAWorkflow *workflow = [EAWorkflow workflowByParsingGeneratorDictionary:workflowDic];
 if (!workflow)
 continue;
 
 workflow.workflowID = i;
 
 [parsedWorkflows addObject:workflow];
 
 
 
 
 int metaworkflowID = ((NSNumber*)workflowDic[@"metaworkflow"]).intValue;
 
 EAMetaworkflow *metaworkflow;
 
 for (EAMetaworkflow *m in parsedMetaworkflows)
 {
 if (m.metaworkflowID)
 {
 metaworkflow = m;
 break;
 }
 }
 
 if (metaworkflow)
 {
 workflow.metaworkflow = metaworkflow;
 [flags raiseFlag:i];
 
 }
 else
 {
 
 [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *m, NSError *error) {
 
 if (!error && m)
 {
 [parsedMetaworkflows addObject:m];
 workflow.metaworkflow = m;
 
 [flags raiseFlag:i];
 
 if (flags.allFlagsRaised)
 {
 completionBlock(self);
 }
 
 
 }
 else
 completionBlock(nil);
 
 }];
 }
 
 
 
 }
 
 _workflows = parsedWorkflows;
 _metaworkflows = parsedMetaworkflows;
 if (flags.allFlagsRaised)
 {
 completionBlock(self);
 }
 
 
 
 
 }
 
 return self;
 
 }*/

-(instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary completion:(void (^) (EASearchResults *))completionBlock
{
    
    if (self = [super init])
    {
        
        
        NSArray *workflows = dictionary[@"workflows"];
        NSLog(@"%@", workflows);
        
        if (!workflows.count)
            completionBlock(nil);
        
        NSMutableArray *parsedWorkflows = [NSMutableArray array];
        NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
        
        
        
        if (!workflows)
        {
            return nil;
            
        }
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_queue_t queue = dispatch_queue_create("com.EASE.task", NULL);
        
        NSMutableArray *flags = [[NSMutableArray alloc] initWithFlags:workflows.count];
        
        
        for (int i = 0; i < workflows.count; i++)
        {
            dispatch_async(queue, ^{
                
                
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                NSDictionary *workflowDic = workflows[i];
                
                
                EAWorkflow *workflow = [EAWorkflow workflowByParsingGeneratorDictionary:workflowDic];
                if (!workflow)
                {
                    [flags raiseFlag:i];
                    /*if (flags.allFlagsRaised)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(self);
                            
                        });
                        
                    }*/
                    dispatch_semaphore_signal(semaphore);

                    return;
                }
                workflow.workflowID = i;
                
                [parsedWorkflows addObject:workflow];
                
                
                
                
                int metaworkflowID = ((NSNumber*)workflowDic[@"metaworkflow"]).intValue;
                
                EAMetaworkflow *metaworkflow;
                
                for (EAMetaworkflow *m in parsedMetaworkflows)
                {
                    if (m.metaworkflowID)
                    {
                        metaworkflow = m;
                        break;
                    }
                }
                
                if (metaworkflow)
                {
                    workflow.metaworkflow = metaworkflow;
                    [flags raiseFlag:i];
                    dispatch_semaphore_signal(semaphore);
                    
                    /*if (flags.allFlagsRaised)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(self);
                            
                        });
                        
                    }*/
                    
                    
                    
                    
                }
                else
                {
                    
                    
                    [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *m, NSError *error) {
                        
                        if (!error && m)
                        {
                            [parsedMetaworkflows addObject:m];
                            workflow.metaworkflow = m;
                            [flags raiseFlag:i];
                            
                            
                        }
                        dispatch_semaphore_signal(semaphore);
                        
                        /*if (flags.allFlagsRaised)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionBlock(self);
                                
                            });
                            
                        }*/
                        
                        
                    }];
                    
                    
                }
                
                
                
            });
        }
        
        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(self);
                
            });
        });
        
        
        
    }
    
    return self;
    
}

/*-(instancetype)initWithSearchDictionary:(NSArray *)array completion:(void (^) (EASearchResults *searchResult))completionBlock
 {
 if (self = [super init])
 {
 NSMutableArray *parsedWorkflows = [NSMutableArray array];
 NSMutableArray *workflowsBeingParsed = [NSMutableArray array];
 
 NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
 NSMutableArray *metaworkflowsBeingParsed = [NSMutableArray array];
 
 NSMutableDictionary *metaworkflowsLinkedToWorkflows = [NSMutableDictionary dictionary];
 
 NSMutableArray *flags = [[NSMutableArray alloc] initWithFlags:array.count];
 
 dispatch_queue_t queue = dispatch_queue_create("com.EASE.searchQueue", NULL);
 dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
 
 
 
 for (int i = 0; i < array.count; i++)
 {
 
 
 
 
 NSDictionary *subtaskDic = array[i];
 int workflowID = ((NSNumber*)subtaskDic[@"WORKFLOW"]).intValue;
 
 BOOL workflowExists = false;
 
 
 for (NSNumber *workflowParsedID in workflowsBeingParsed)
 if (workflowParsedID.integerValue == workflowID)
 {
 workflowExists = true;
 break;
 }
 
 if (workflowExists)
 {
 [flags raiseFlag:i];
 continue;
 }
 [workflowsBeingParsed addObject:@(workflowID)];
 
 
 
 [[EANetworkingHelper sharedHelper] retrieveWorkflowWithID:workflowID completionBlock:^(EAWorkflow *workflow, int metaworkflowID, NSError *error) {
 
 if (error || !workflow)
 {
 completionBlock(nil);
 return;
 }
 [parsedWorkflows addObject:workflow];
 
 
 
 
 BOOL metaworkflowExists = false;
 
 for (EAMetaworkflow *metaworkflow in parsedMetaworkflows)
 {
 if (metaworkflowID == metaworkflow.metaworkflowID)
 {
 metaworkflowExists = true;
 
 workflow.metaworkflow = metaworkflow;
 
 break;
 }
 }
 
 if (!metaworkflowExists)
 {
 
 for (NSNumber *metaworkflowParsedID in metaworkflowsBeingParsed)
 {
 if (metaworkflowID == metaworkflowParsedID.intValue)
 {
 metaworkflowExists = true;
 
 if (!metaworkflowsLinkedToWorkflows[@(metaworkflowID)])
 [metaworkflowsLinkedToWorkflows addEntriesFromDictionary:@{@(metaworkflowID) : [ NSMutableArray arrayWithObject:workflow]}];
 else
 [metaworkflowsLinkedToWorkflows[@(metaworkflowID)] addObject:workflow];
 
 
 
 break;
 }
 
 }
 
 }
 
 
 
 
 if (!metaworkflowExists)
 {
 if (!metaworkflowsLinkedToWorkflows[@(metaworkflowID)])
 [metaworkflowsLinkedToWorkflows addEntriesFromDictionary:@{@(metaworkflowID) : [ NSMutableArray arrayWithObject:workflow]}];
 else
 [metaworkflowsLinkedToWorkflows[@(metaworkflowID)] addObject:workflow];
 
 
 [metaworkflowsBeingParsed addObject:@(metaworkflowID)];
 [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
 [parsedMetaworkflows addObject:metaworkflow];
 
 
 NSArray *workflowsWaitingForMetaworkflows = metaworkflowsLinkedToWorkflows[@(metaworkflow.metaworkflowID)];
 
 for (EAWorkflow *workflowWaiting in workflowsWaitingForMetaworkflows)
 workflowWaiting.metaworkflow = metaworkflow;
 
 
 
 
 
 
 
 [flags raiseFlag:i];
 if (flags.allFlagsRaised)
 completionBlock(self);
 
 }];
 
 
 }
 else
 {
 [flags raiseFlag:i];
 if (flags.allFlagsRaised)
 completionBlock(self);
 
 }
 
 
 }];
 
 
 
 
 
 
 }
 
 _workflows = parsedWorkflows;
 _metaworkflows = parsedMetaworkflows;
 
 if (flags.allFlagsRaised)
 completionBlock(self);
 
 
 }
 
 return self;
 }*/

-(instancetype)initWithSearchDictionary:(NSArray *)array completion:(void (^) (EASearchResults *searchResult))completionBlock
{
    if (self = [super init])
    {
        NSMutableArray *parsedWorkflows = [NSMutableArray array];
        NSMutableArray *workflowsBeingParsed = [NSMutableArray array];
        
        NSMutableArray *parsedMetaworkflows = [NSMutableArray array];
        NSMutableArray *metaworkflowsBeingParsed = [NSMutableArray array];
        
        NSMutableDictionary *metaworkflowsLinkedToWorkflows = [NSMutableDictionary dictionary];
        
        NSMutableArray *flags = [[NSMutableArray alloc] initWithFlags:array.count];
        
        dispatch_queue_t queue = dispatch_queue_create("com.EASE.searchQueue", NULL);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        
        
        for (int i = 0; i < array.count; i++)
        {
            dispatch_async(queue, ^{
                
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                
                
                NSDictionary *subtaskDic = array[i];
                int workflowID = ((NSNumber*)subtaskDic[@"WORKFLOW"]).intValue;
                
                BOOL workflowExists = false;
                
                
                for (NSNumber *workflowParsedID in workflowsBeingParsed)
                    if (workflowParsedID.integerValue == workflowID)
                    {
                        workflowExists = true;
                        break;
                    }
                
                if (workflowExists)
                {
                    [flags raiseFlag:i];
                    if (flags.allFlagsRaised)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(self);
                            
                        });
                    }

                    dispatch_semaphore_signal(semaphore);
                    return;
                }
                [workflowsBeingParsed addObject:@(workflowID)];
                
                
                
                [[EANetworkingHelper sharedHelper] retrieveWorkflowWithID:workflowID completionBlock:^(EAWorkflow *workflow, int metaworkflowID, NSError *error) {
                    
                    if (error || !workflow)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil);

                        });
                        
                        return;
                    }
                    [parsedWorkflows addObject:workflow];
                    
                    
                    
                    
                    BOOL metaworkflowExists = false;
                    
                    for (EAMetaworkflow *metaworkflow in parsedMetaworkflows)
                    {
                        if (metaworkflowID == metaworkflow.metaworkflowID)
                        {
                            metaworkflowExists = true;
                            
                            workflow.metaworkflow = metaworkflow;
                            
                            break;
                        }
                    }
                    
                    /*if (!metaworkflowExists)
                    {
                        
                        for (NSNumber *metaworkflowParsedID in metaworkflowsBeingParsed)
                        {
                            if (metaworkflowID == metaworkflowParsedID.intValue)
                            {
                                metaworkflowExists = true;
                                
                                if (!metaworkflowsLinkedToWorkflows[@(metaworkflowID)])
                                    [metaworkflowsLinkedToWorkflows addEntriesFromDictionary:@{@(metaworkflowID) : [ NSMutableArray arrayWithObject:workflow]}];
                                else
                                    [metaworkflowsLinkedToWorkflows[@(metaworkflowID)] addObject:workflow];
                                
                                
                                
                                break;
                            }
                            
                        }
                        
                    }*/
                    
                    
                    

                    if (!metaworkflowExists)
                    {
                        if (!metaworkflowsLinkedToWorkflows[@(metaworkflowID)])
                            [metaworkflowsLinkedToWorkflows addEntriesFromDictionary:@{@(metaworkflowID) : [ NSMutableArray arrayWithObject:workflow]}];
                        else
                            [metaworkflowsLinkedToWorkflows[@(metaworkflowID)] addObject:workflow];
                        
                        
                        [metaworkflowsBeingParsed addObject:@(metaworkflowID)];
                        
                        
                        [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *metaworkflow, NSError *error) {
                            [parsedMetaworkflows addObject:metaworkflow];
                            
                            
                            NSArray *workflowsWaitingForMetaworkflows = metaworkflowsLinkedToWorkflows[@(metaworkflow.metaworkflowID)];
                            
                            for (EAWorkflow *workflowWaiting in workflowsWaitingForMetaworkflows)
                                workflowWaiting.metaworkflow = metaworkflow;
                            
                            
                            
                            
                            
                            dispatch_semaphore_signal(semaphore);
                            [flags raiseFlag:i];
                            
                        }];
                        
                        
                    }
                    else
                    {
                        
                        dispatch_semaphore_signal(semaphore);
                        [flags raiseFlag:i];
                        
                    }
                    
                    
                }];
                
                
                
                
                
                
            });
        }
        
        
        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(self);
                
            });
        });
        
        
    }
    
    return self;
}

@end
