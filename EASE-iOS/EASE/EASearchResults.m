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
        NSMutableArray *parsedMetaworkflows = [NSMutableArray array];

        
        if (!workflows)
            return nil;
        
        for (int i = 0; i < workflows.count; i++)
        {
            NSDictionary *workflowDic = workflows[i];

            
            EAWorkflow *workflow = [EAWorkflow workflowByParsingDictionary:workflowDic];
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
            }
            else
            {
                
                [[EANetworkingHelper sharedHelper] retrieveMetaworkflowWithID:metaworkflowID completionBlock:^(EAMetaworkflow *m, NSError *error) {
                   
                    if (!error && m)
                    {
                        [parsedMetaworkflows addObject:m];
                        workflow.metaworkflow = m;
                    }
                    
                }];
            }
            
            
            
            
        }
        
        _workflows = parsedWorkflows;
        _metaworkflows = parsedMetaworkflows;
        
        
    }
    
    return self;
    
}


@end
